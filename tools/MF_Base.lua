--------------------------------------------------------------------------
-- This the base class for Module file output.
-- @classmod MF_Base

require("strict")

--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lmod is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2018 Robert McLay
--
--  Permission is hereby granted, free of charge, to any person obtaining
--  a copy of this software and associated documentation files (the
--  "Software"), to deal in the Software without restriction, including
--  without limitation the rights to use, copy, modify, merge, publish,
--  distribute, sublicense, and/or sell copies of the Software, and to
--  permit persons to whom the Software is furnished to do so, subject
--  to the following conditions:
--
--  The above copyright notice and this permission notice shall be
--  included in all copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
--  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
--  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
--  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
--  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
--  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
--  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--  THE SOFTWARE.
--
--------------------------------------------------------------------------

require("declare")
require("inherits")
require("string_utils")

local M            = {}

local load         = (_VERSION == "Lua 5.1") and loadstring or load
local dbg          = require("Dbg"):dbg()
local concatTbl    = table.concat
local pairsByKeys  = pairsByKeys


--------------------------------------------------------------------------
-- returns the derived class's name: (e.g. bash)
-- @param self MF_Base object
function M.name(self)
   return self.my_name
end

s_mfT = false

--------------------------------------------------------------------------
-- This is the factory that builds the derived shell.
-- @param kind the kind of derived MF_Base class to build.
function M.build(kind)
   if (not s_mfT) then
      local MF_Lua  = require("MF_Lua")
      local MF_TCL  = require("MF_TCL")
      s_mfT         = {}
      s_mfT["lmod"] = MF_Lua
      s_mfT["lua"]  = MF_Lua
      s_mfT["tcl"]  = MF_TCL
   end
   kind = (kind or ""):lower()
   local mkind = s_mfT[kind] or s_mfT['lua']
   return mkind:create()
end

local function l_safe_eval(name, s)
   local f, err = load(s)
   if (not f) then
      io.stderr:write(name, ": Syntax error: ",err,"\n")
      io.stderr:write(s,"\n")
      os.exit(1)
   end
   local ok, result = pcall(f)
   if (not ok) then
      io.stderr:write(name,": run error: ",tostring(result),"\n")
      io.stderr:write(s,"\n")
      os.exit(1)
   end
end


--------------------------------------------------------------------------
-- Compare the old env table with the new and generate differences.
-- @param self MF_Base object
-- @param ignoreT table of env. vars to ignore.
-- @param oldEnvT The original user environment.
-- @param envT The new user environment.
function M.process(self, shellName, ignoreT, resultT)
   dbg.start{"MF_Base:process(shellName, ignoreT, resultT)"}
   local a = {}
   
   -- load oldEnvT and envT environment
   declare("oldEnvT")
   declare("envT")
   l_safe_eval("oldEnvT",resultT["Vars"][1])
   l_safe_eval("envT",   resultT["Vars"][2])
   
   self:processVars(ignoreT, oldEnvT, envT, a)
   
   self:processAliases(  shellName, resultT["Aliases"][1],  resultT["Aliases"][2],  a)

   self:processFuncs(    shellName, resultT["Funcs"][1],    resultT["Funcs"][2],    a)

   self:processComplete( shellName, resultT["Complete"][1], resultT["Complete"][2], a)

   dbg.fini("MF_Base:process")
   return a
end

local shellAliasPatt = {
   bash = { namePatt  = "alias ([a-zA-Z0-9_.?']+)='", trailingPatt = "'\n"  },
   tcsh = { namePatt  = "([a-zA-Z0-9_.?']+)\t%(?",    trailingPatt = "%)?\n"},
   zsh  = { namePatt  = "([a-zA-Z0-9_.?']+)='",       trailingPatt = "'\n"  },
   ksh  = { namePatt  = "([a-zA-Z0-9_.?']+)='",       trailingPatt = "'\n"  },
}


local function l_extractAliases(shellName, aliases)
   local aliasT       = {}
   local namePatt     = shellAliasPatt[shellName].namePatt
   local trailingPatt = shellAliasPatt[shellName].trailingPatt

   while (true) do
      local is, ie, Nm = aliases:find(namePatt)
      if (not is) then break end
      local js, je     = aliases:find(trailingPatt, ie+1)
      aliasT[Nm]       = aliases:sub(ie+1,js-1)
      aliases          = aliases:sub(je+1,-1)
   end

   return aliasT
end
   
function M.processAliases(self, shellName, old, new, a)
   dbg.start{"MF_Base:processAliases(shellName, old, new, a)"}

   local oldAliasT = l_extractAliases(shellName, old)
   local aliasT    = l_extractAliases(shellName, new)

   for k,v in pairsByKeys(aliasT) do
      local oldV = oldAliasT[k]
      if (oldV == nil or oldV ~= v) then
         a[#a+1] = self:alias(k,v)
      end
   end
   dbg.fini("MF_Base:processAliases")
end

local shellFuncPatt = {
   bash = { namePatt  = "([-a-zA-Z0-9_.?']+) ?%(%)%s+({)", trailingPatt = "\n(})\n" },
   zsh  = { namePatt  = "([-a-zA-Z0-9_.?']+) ?%(%)%s+({)", trailingPatt = "\n(})\n" },
   ksh  = { namePatt  = "([-a-zA-Z0-9_.?']+) ?%(%)%s+({)", trailingPatt = "\n(})\n" },
}

local function l_extractFuncs(shellName, funcs)
   local funcT        = {}
   local namePatt     = shellFuncPatt[shellName].namePatt
   local trailingPatt = shellFuncPatt[shellName].trailingPatt

   while (true) do
      local is, ie, Nm, Strt = funcs:find(namePatt)
      if (not is) then break end
      local js, je, End      = funcs:find(trailingPatt, ie+1)
      funcT[Nm]              = funcs:sub(ie+1,js):gsub("\t","    ")
      funcs                  = funcs:sub(je+1,-1)
   end

   return funcT
end
      
   
function M.processFuncs(self, shellName, old, new, a)
   dbg.start{"MF_Base:processFuncs(shellName, old, new, a)"}
   if (not shellFuncPatt[shellName] ) then return end

   local oldFuncT = l_extractFuncs(shellName, old)
   local funcT    = l_extractFuncs(shellName, new)
   
   for k,v in pairsByKeys(funcT) do
      local oldV = oldFuncT[k]
      if (oldV == nil or oldV ~= v) then
         a[#a+1] = self:shell_function(k,v)
      end
   end

   dbg.fini("MF_Base:processFuncs")
end

local shellCompletePatt = {
   bash = { namePatt = "([a-zA-Z0-9_.?']+)$",  frontPatt = "^complete  *", bodyPatt = "(.*)"},
   tcsh = { namePatt = "^([a-zA-Z0-9_.?']+) ", frontPatt = "",             bodyPatt = "'([^']*)'"},
}

local function l_extractComplete(shellName, complete)
   local completeT = {}
   local namePatt  = shellCompletePatt[shellName].namePatt
   local bodyPatt  = shellCompletePatt[shellName].bodyPatt
   local frontPatt = shellCompletePatt[shellName].frontPatt
   local Nm
   local body
   while (true) do
      local is, ie     = complete:find("\n")
      if (not is) then break end
      local s          = complete:sub(1, is-1)
      complete         = complete:sub(ie+1, -1)
      s                = s:gsub(frontPatt,"")
      is, ie, Nm       = s:find(namePatt)
      s                = s:sub(1,is-1) .. s:sub(ie+1,-1)
      s                = s:trim()
      is, ie, body     = s:find(bodyPatt)
      completeT[Nm]    = body
   end
   return completeT
end



function M.processComplete(self, shellName, old, new, a)
   dbg.start{"MF_Base:processComplete(shellName, old, new, a)"}
   if (not shellCompletePatt[shellName] ) then return end
   local oldCompleteT = l_extractComplete(shellName, old)
   local completeT    = l_extractComplete(shellName, new)
   for k,v in pairsByKeys(completeT) do
      local oldV = oldCompleteT[k]
      if (oldV == nil or oldV ~= v) then
         a[#a+1] = self:complete(shellName,k, v)
      end
   end

   dbg.fini("MF_Base:processComplete")
end



function l_indexPath(old, oldA, new, newA)
   --dbg.start{"l_indexPath(",old, ", ", new,")"}
   local oldN = #oldA
   local newN = #newA
   local idxM = newN - oldN + 1

   if (oldN >= newN or newN == 1) then
      if (old == new) then
         --dbg.fini("(1) l_indexPath")
         return 1
      end
      --dbg.fini("(2) l_indexPath")
      return -1
   end

   local icnt = 1

   local idxO = 1
   local idxN = 1

   while (true) do
      local oldEntry = oldA[idxO]
      local newEntry = newA[idxN]

      icnt = icnt + 1
      if (icnt > newN) then
         break
      end


      if (oldEntry == newEntry) then
         idxO = idxO + 1
         idxN = idxN + 1

         if (idxO > oldN) then break end
      else
         idxN = idxN + 2 - idxO
         idxO = 1
         if (idxN > idxM) then
            --dbg.fini("(3) l_indexPath")
            return -1
         end
      end
   end

   idxN = idxN - idxO + 1

   --dbg.print{"idxN: ", idxN, "\n"}

   --dbg.fini("l_indexPath")
   return idxN

end


function l_splice(a, is, ie)
   local b = {}
   for i = 1, is-1 do
      b[i] = a[i]
   end

   for i = ie+1, #a do
      b[#b+1] = a[i]
   end
   return b
end

function M.processVars(self, ignoreT, oldEnvT, envT, a)
   dbg.start{"MF_Base:processVars(ignoreT, oldEnvT, envT, a)"}

   ------------------------------------------------------------
   -- Add header to modulefile if necessary.
   -- Include the "#%Module" magic string For TCL modulefiles

   local s = self:header()
   if (s) then
      a[#a+1] = s
   end

   --dbg.print{"name: ",self:name(), "\n"}

   local mt_pat = "^_ModuleTable"
   for k, v in pairsByKeys(envT) do
      local i = k:find(mt_pat)
      if (not ignoreT[k] and not i) then
         --dbg.print{"k: ", k, ", v: ", v, ", oldV: ",oldEnvT[k],"\n"}
         local oldV = oldEnvT[k]
         if (not oldV) then
            a[#a+1] = self:setenv(k,v)
         else
            local oldA = path2pathA(oldV)
            local newA = path2pathA(v)
            local idx  = l_indexPath(oldV, oldA, v, newA)
            if (idx < 0) then
               a[#a+1] = self:setenv(k,v)
            else
               newA = l_splice(newA, idx, #oldA + idx - 1)
               for j = idx-1, 1, -1 do
                  a[#a+1] = self:prepend_path(k,newA[j])
               end
               for j = idx, #newA do
                  a[#a+1] = self:append_path(k,newA[j])
               end
            end
         end
      end
   end

   dbg.fini("MF_Base:processVars")
end

function M.complete(self, shellName, name, value)
end

function M.header(self)
   return nil
end

return M

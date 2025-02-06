--------------------------------------------------------------------------
-- This file contains the lua based function used by the lua based
-- .modulerc.lua files

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
require("deepcopy")
require("utils")
local pack         = (_VERSION == "Lua 5.1") and argsPack or table.pack -- luacheck: compat

local function l_validateStringArgs(cmdName, ...)
   local argA = pack(...)
   for i = 1, argA.n do
      local v = argA[i]
      if (type(v) ~= "string") then
         mcp:report{msg="e_Args_Not_Strings", fn = myMRC_file(), cmdName = cmdName}
         return false
      end
   end
   return true
end

--module_version("module_name","v1","v2"...)
function module_version(module_name, ...)
   if (not l_validateStringArgs("module_version", module_name, ...)) then return end
   local argA = pack(...)
   argA.n     = nil
   ModA[#ModA+1] = {action="module_version", module_name=module_name, module_versionA=argA}
end

--module_alias("name","modulefile")
function module_alias(name,mfile)
   if (not l_validateStringArgs("module_version", name, mfile)) then return end
   ModA[#ModA+1] = {action="module_alias", name=name, mfile=mfile}
end

--hide_version("full_module_version")
function hide_version(full)
   if (not l_validateStringArgs("hide_version", full)) then return end
   ModA[#ModA+1] = {action="hide_version", mfile=full}
end


--hide_modulefile("/path/to/modulefile")
function hide_modulefile(path)
   if (not l_validateStringArgs("hide_modulefile", path)) then return end
   ModA[#ModA+1] = {action="hide_modulefile", mfile=path}
end

local function l_hide_forbid(function_name, default_kind, argT, rulesT)
   if (type(argT) ~= "table") then
      mpc:report{msg="e_Args_Not_Table",func=function_name,fn=myMRC_file()}
   end
   argT.action = function_name
   argT.kind   = argT.kind or default_kind

   ------------------------------------------------------------------------
   -- Convert t.name to t.nameA if necessary

   local v     = argT.name
   if (type(v) == "string") then
      argT.nameA = { v }
   elseif (type(v) == "table") then
      argT.nameA = v
   elseif (v) then
      LmodError{msg="e_Unknown_v_type",func=function_name, key="name", value=v,
                tkind = type(v), kind=entry.kind}
   end
   argT.name  = nil

   ------------------------------------------------------------------------
   -- Check for valid table from site.

   for k,v in pairs(argT) do
      local entry = rulesT[k]
      if (entry == nil) then
         LmodError{msg="e_Unknown_key",key=k,func=function_name}
      end
      if ( type(v) == "table" and entry.kind == "stringArray") then
         for i = 1,#v do
            if (type(v[i]) ~= "string") then
               LmodError{msg="e_Unknown_v_type",func=function_name,key=k, value=v[i],
                         tkind = type(v[i]), kind=entry.kind}
            end
         end
      elseif ( type(v) ~= entry.kind) then
         LmodError{msg="e_Unknown_v_type",func=function_name,key=k, value=v,
                   tkind = type(v), kind=entry.kind}
      end
      local choiceT = entry.choiceT
      if (choiceT and not choiceT[v]) then
         LmodError{msg="e_Unknown_value",func=function_name,key=k,value=v}
      end
   end

   --------------------------------------------------
   -- expand argT.nameA into separate entries in ModA
   -- For each entry convert userA -> userT, groupA -> groupT etc.

   for i = 1,#argT.nameA do
      local entry   = {}
      entry.name    = argT.nameA[i]
      for k,v in pairs(argT) do
         if (k == "nameA") then
            -- Do nothing
         elseif (k:find("A$")) then
            local key = k:gsub("A$","T")
            local t   = {}
            for i=1,#v do
               t[v[i]] = true
            end
            entry[key] = t
         else
            entry[k] = v
         end
      end
      ModA[#ModA+1] = entry
   end
end



local hide_rulesT = {
   action        = {kind="string", choiceT = {hide = true}},
   nameA         = {kind="stringArray"},
   userA         = {kind="stringArray"},
   groupA        = {kind="stringArray"},
   notUserA      = {kind="stringArray"},
   notGroupA     = {kind="stringArray"},
   after         = {kind="string"},
   before        = {kind="string"},
   kind          = {kind="string", choiceT = {hard = true, soft = true, hidden = true}},
   hidden_loaded = {kind="boolean"},
}

function hide(t)
   l_hide_forbid("hide","hidden", t, hide_rulesT)
end

local forbid_rulesT = {
   action         = {kind="string", choiceT = {forbid = true}},
   nameA          = {kind="stringArray"},
   userA          = {kind="stringArray"},
   groupA         = {kind="stringArray"},
   notUserA       = {kind="stringArray"},
   notGroupA      = {kind="stringArray"},
   after          = {kind="string"},
   before         = {kind="string"},
   message        = {kind="string"},
   nearly_message = {kind="string"},
}
function forbid(t)
   l_hide_forbid("forbid", nil, t, forbid_rulesT)
end


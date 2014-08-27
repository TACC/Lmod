------------------------------------------------------------------------
--
--  Copyright (C) 2008-2014 Robert McLay
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

-- Optiks.lua

local function argsPack(...)
   local arg = { n = select ("#", ...), ...}
   return arg
end
local pack        = (_VERSION == "Lua 5.1") and argsPack or table.pack

function Optiks_Error(...)
   io.stderr:write("\n",ProgName,"Error: ")
   local arg = pack(...)
   for i = 1, arg.n do
      io.stderr:write(arg[i])
   end
   io.stderr:write("\n")
   os.exit(1)
end

function Optiks_Exit(v)
   os.exit(v)
end

require("strict")
require("TermWidth")
require("declare")

local M            = {}

local BeautifulTbl = require("BeautifulTbl")
local Error        = Optiks_Error
local Exit         = Optiks_Exit
local Option       = require("Optiks_Option")
local ProgName     = ""
local arg          = arg
local concatTbl    = table.concat
local io           = io
local ipairs       = ipairs
local os           = os
local pairs        = pairs
local print        = print
local require      = require
local require      = require
local setmetatable = setmetatable
local systemG      = _G
local table        = table
local tonumber     = tonumber
local tostring     = tostring
local type         = type
local stdout       = io.stdout

local function Prt(...)
   stdout:write(...)
end

local function PrtEnd()
end

icnt = 0

function M.new(self, t)
   local o = {}
   setmetatable(o, self)
   self.__index   = self
   self.argNames  = {}
   self.optA      = {}

   local envArg   = nil
   local usage    = t
   local version  = nil
   if (type(t) == "table") then
      usage    = t.usage
      ProgName = t.progName
      version  = t.version
      envArg   = t.envArg

      Error    = t.error or Error
      Prt      = t.prt or Prt
      PrtEnd   = t.prtEnd or PrtEnd
      Exit     = t.exit or Exit
   end

   if (not isDefined("ProgName") or not ProgName or ProgName == "") then
      declare("ProgName","")
   else
      ProgName = ProgName .. " "
   end

   o.exit     = Exit
   o.prt      = Prt
   o.prtEnd   = PrtEnd
   o.usage    = usage
   o.version  = version
   o.envArg   = envArg
   if (usage == nil) then
      local cmd  = arg[0]
      local i,j  = cmd:find(".*/")
      if (i) then
         cmd = cmd:sub(j+1)
      end
      o.usage = "Usage: " .. cmd .. " [options]"
   end

   o.dispTbl  = {
      append      = M.display_store,
      count       = M.display_count,
      store       = M.display_store,
      store_true  = M.display_flag,
      store_false = M.display_flag,
   }

   return o
end

function M.add_option(self, myTable)
   local opt           = Option:new(myTable)
   local names         = opt:optionNames()
   local systemDefault = opt.table.system
   local safeToAdd     = true

   for i,v in ipairs(names) do
      local _, _, dash, key = v:find("^(%-%-?)([^=-][^=]*)")

      local exists = self.argNames[key]
      if (not exists) then
         self.argNames[key] = opt.table
      else
         safeToAdd = false
         if (not systemDefault) then
            Error("duplicate option: \"" .. v .. "\"\n")
         end
      end
   end

   if (safeToAdd) then
      table.insert(self.optA, opt)
   end
end

function M.getValue(self, arg, argIn, o, optName)
   local result
   if (arg) then
      result = arg
   else
      result = argIn[1]
      if (result == nil) then
         Error("No value given for option: \"" .. optName .. "\"\n")
      end
      table.remove(argIn,1)
   end
   if (o.type == "number" ) then
      result = tonumber(result)
   end
   return result
end


function M.store(self, arg, argIn, argTbl, o, optName)
   return self:getValue(arg,argIn, o, optName)
end

function M.store_true(self, arg, argIn, argTbl, o, optName)
   return true
end

function M.append(self, arg, argIn, argTbl, o, optName)
   local result = self:getValue(arg, argIn, o, optName)

   table.insert(argTbl[o.dest], result)

   return argTbl[o.dest]
end

function M.store_false(self, arg, argIn, argTbl, o, optName)
   return false
end

function M.count(self, arg, argIn, argTbl, o, optName)
   return argTbl[o.dest] + 1
end

-----------------------------------------------------------
-- Display functions

function M.display_store(self, opt)
   local a    = {}
   local dest = opt.dest or ""
   local s    = ""
   for _,v in ipairs(opt.name) do
      if (v:len() < 3) then
         s = v .. " " .. dest
      else
         s = v .. "=" .. dest
      end
      a[#a + 1] = s
   end
   return table.concat(a," ")
end

function M.display_flag(self, opt)
   local a = {}
   for _,v in ipairs(opt.name) do
      a[#a + 1] = v
   end
   return table.concat(a," ")
end

function M.display_count(self, opt)
   return self:display_flag(opt)
end

function M.setDefaults(self, argTbl)
   for i,v in ipairs(self.optA) do
      v:setDefault(argTbl)
   end
end

-----------------------------------------------------------
-- The Big Kahuna: This does all the work

function M.parseOpt(self, optName, arg, argIn, argTbl)
   local o = self.argNames[optName]
   if (o ~= nil) then
      argTbl[o.dest] = self[o.action](self, arg, argIn, argTbl, o, optName)
   else
      Error("Unknown Option: \"" .. optName .. "\"\n")
   end
end

function M.buildHelpMsg(self)
   local term_width  = TermWidth()
   local b = {}
   b[#b+1] = self.usage
   b[#b+1] = "\n\nOptions:\n"

   local a = {}
   for _,v  in ipairs(self.optA) do
      local opt = v.table
      a[#a + 1] = { "  " .. self.dispTbl[opt.action](self, opt), opt.help or " " }
   end

   local bt = BeautifulTbl:new{tbl=a, wrapped=true, column=term_width-1}
   b[#b+1] = bt:build_tbl()
   b[#b+1] = "\n"

   return concatTbl(b,"")
end

function M.printHelp(self)
   self.prt(self:buildHelpMsg())
   self.exit(0)
end


function M.parseEnvArg(self)
   local optA   = {}
   local optStr = self.envArg
   if (optStr == nil) then
      return optA
   end

   local done   = false

   local idx    = 1
   local len    = optStr:len()
   local i, j, k, q, c
   
   while (not done) do
      while (true) do
         -- remove leading spaces
         j, k = optStr:find("%s+",idx)
         if (k) then
            idx = k + 1
         end
         if (idx > len) then
            done = true
            break
         end

         -- look for a quoted string
         c = optStr:sub(idx,idx)
         if (c == "\"" or c == "'") then
            q             = c
            j             = optStr:find(q,idx+1) or 0
            optA[#optA+1] = optStr:sub(idx+1, j-1)
            done          = (j == 0)
            break
         end

         -- find end of argument
         i = optStr:find("%s",idx) or 0
         optA[#optA+1] = optStr:sub(idx, i-1)
         if (i == 0) then
            done = true
            break
         end
         idx = i
      end
   end
   return optA
end


function M.parse(self, argIn)

   ------------------------------------------------------------
   -- add these options if the client has not already set them.

   self:add_option{
      name    = {"-h", "-?", "--help"},
      dest    = "Optiks_help",
      action  = "store_true",
      help    = "Show this help message and exit",
      system  = true,
   }

   if (self.version) then
      self:add_option{
         name    = {"--version"},
         dest    = "Optiks_version",
         action  = "store_true",
         help    = "Output version info and exit",
         system  = true,
      }
   end


   local argA = self:parseEnvArg()
   for i = 1,#argIn do
      argA[#argA+1] = argIn[i]
   end

   local noProcess = nil
   local parg      = {}
   local argTbl    = {[0] = argA[0]}
   self:setDefaults(argTbl)
   while (argA[1]) do
      local key = argA[1]
      table.remove(argA,1)
      local _, _, dash, optName = key:find("^(%-%-?)([^=-][^=]*)")
      local _, _, arg           = key:find("=(.*)")
      if (key == "--") then
         noProcess = 1
      elseif (dash == nil or noProcess) then
         table.insert(parg, key)
         noProcess = 1
      else
         self:parseOpt(optName, arg, argA, argTbl)
      end
   end
   if (argTbl.Optiks_help) then
      self:printHelp()
   end
   if (argTbl.Optiks_version) then
      self.prt(self.version .. "\n")
      self.exit()
   end
   return argTbl, parg
end

return M

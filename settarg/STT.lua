--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lua is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2013 Robert McLay
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

--------------------------------------------------------------------------
-- STT:  This class manages the Settarg Table.  This table records the
--       state of the settarg variables.


require("strict")
require("serializeTbl")
require("utils")

_SettargTable_ = ""


local M         = {}
local Dbg       = require("Dbg")
local concatTbl = table.concat
local dbg       = Dbg:dbg()
local load      = (_VERSION == "Lua 5.1") and loadstring or load

s_stt = false

local function stt_version()
   return 1
end

local function new(self, s)
   dbg.start("STT:new(s)")
   local o   = {}

   
   if (not s) then
      local targT = {}
      targT.build_scenario_state = "empty"
      targT.extraA               = {}
      o.targT                    = targT
      o.version                  = stt_version()
   else
      assert(load(s))()
      local _SettargTable_ = _G._SettargTable_
      for k, v in pairs(_SettargTable_) do
         o[k] = v
      end

      if (o.version ~= stt_version()) then



   end

   setmetatable(o, self)
   self.__index  = self
   dbg.fini("STT:new")
   return o
end

function M.stt(self)
   if (not s_stt) then
      dbg.start("STT:stt()")
      s_stt = new(self, getSTT())
      dbg.fini("STT:stt")
   end
   return s_stt
end


function M.serializeTbl(self)
   local s = serializeTbl{indent = false, name = "_SettargTable_", value = self}
   return s:gsub("%s+","")
end


return M

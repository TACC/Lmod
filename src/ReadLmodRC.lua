--------------------------------------------------------------------------
-- This class controls the ModuleTable.  The ModuleTable is how Lmod
-- communicates what modules are loaded or inactive and so on between
-- module commands.
--
-- @classmod ReadLmodRC

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
--  Copyright (C) 2008-2025 Robert McLay
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
require("utils")
require("myGlobals")


local M       = {}
local dbg     = require("Dbg"):dbg()
local cosmic  = require("Cosmic"):singleton()
local getenv  = os.getenv
local open    = io.open

local s_classObj    = false

local function l_buildRC(self)
   dbg.start{"l_buildRC(self)"}

   declare("propT",       false)
   declare("scDescriptT", false)
   local s_propT       = {}
   local s_scDescriptT = {}
   local s_rcFileA     = {}
   local configDir     = cosmic:value("LMOD_CONFIG_DIR")
   local RCFileA       = {
      pathJoin(cmdDir(),"../init/lmodrc.lua"),
      pathJoin(cmdDir(),"../../etc/lmodrc.lua"),
      pathJoin(configDir, "lmodrc.lua"),
      "/etc/lmodrc.lua",
      pathJoin(getenv("HOME"),".lmodrc.lua"),
   }

   local lmodrc_env = cosmic:value("LMOD_RC")
   if (lmodrc_env:len() > 0) then
      for rc in lmodrc_env:split(":") do
         RCFileA[#RCFileA+1] = rc
      end
   end

   for i = 1,#RCFileA do
      repeat
         local f  = RCFileA[i]
         local fh = open(f)
         if (not fh) then break end

         assert(loadfile(f))()
         s_rcFileA[#s_rcFileA+1] = f
         fh:close()

         local propT       = _G.propT or {}
         local scDescriptT = _G.scDescriptT   or {}
         for k,v in pairs(propT) do
            s_propT[k] = v
         end
         for j = 1,#scDescriptT do
            s_scDescriptT[#s_scDescriptT + 1] = scDescriptT[j]
         end
      until true
   end

   self.__propT       = s_propT
   self.__scDescriptT = s_scDescriptT
   self.__rcFileA     = s_rcFileA

   dbg.fini("l_buildRC")
end


local function l_new(self)
   dbg.start{"ReadLmodRC:l_new()"}
   local o = {}
   setmetatable(o,self)
   self.__index = self

   l_buildRC(o)

   dbg.fini("ReadLmodRC:l_new")
   return o
end

function M.validPropValue(self,  name, value, t)
   dbg.start{"ReadLmodRC:validPropValue(\"",name,"\", \"", value,"\", t)"}
   local propDisplayT = self:propT()
   local propKindT    = propDisplayT[name]

   if (propKindT == nil) then
      LmodError{msg="e_No_PropT_Entry", routine = "MT:add_property()", location = "entry", name = name}
   end
   local validT = propKindT.validT
   if (validT == nil) then
      LmodError{msg="e_No_PropT_Entry", routine = "MT:add_property()", location = "validT table", name = name}
   end

   for v in value:split(":") do
      if (validT[v] == nil) then
         LmodError{msg="e_No_ValidT_Entry", routine = "MT:add_property()", name = name, value = value}
      end
      t[v] = 1
   end
   dbg.fini("ReadLmodRC:validPropValue")
end


function M.singleton(self)
   dbg.start{"ReadLmodRC:singleton()"}
   if (not s_classObj) then
      s_classObj = l_new(self)
   end
   dbg.fini("ReadLmodRC:singleton")
   return s_classObj
end

function M.propT(self)
   return self.__propT
end

function M.scDescriptT(self)
   return self.__scDescriptT
end

function M.rcFileA(self)
   return self.__rcFileA
end

return M


-- This file loads the .modulerc.lua, .modulerc and .version files
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

require("fileOps")
require("mrc_sandbox")

local dbg  = require("Dbg"):dbg()
local load = (_VERSION == "Lua 5.1") and loadstring or load
local s_fn = false

function myMRC_file()
   return s_fn
end

function mrc_load(fn)
   dbg.start{"mrc_load(fn:",fn,")"}
   local whole
   local ok
   local func
   local msg
   local status

   declare("ModA",false)
   ModA = {}
   s_fn = path_regularize(fn)
   local myType = extname(s_fn)
   if (myType == ".lua") then
      local f = io.open(s_fn)
      whole   = false
      if (f) then
         whole = f:read("*all")
         dbg.start{"RC_File(",s_fn,")"}
         dbg.print{whole}
         dbg.fini("RC_File")
         f:close()
      end
      if (whole) then
         status, msg = mrc_sandbox_run(whole)
      else
         status = nil
         msg    = "Unreadable or Empty or non-existent file"
      end
      if (not status) then
         LmodWarning{msg="e_Unable_2_Load", name = "<unknown>", fn = s_fn, message = msg}
      end
   else
      whole, ok = runTCLprog(pathJoin(cmdDir(),"RC2lua.tcl"), s_fn)
      if (not ok) then
         LmodError{msg = "e_Unable_2_parse", path = s_fn}
      end

      ok, func = pcall(load, whole)
      if (not ok or not func) then
         LmodError{msg = "e_Unable_2_parse", path = s_fn}
      end
      if (func) then
         func()
      end
   end
   --dbg.printT("ModA",ModA)
   dbg.fini("mrc_load")
   return ModA
end

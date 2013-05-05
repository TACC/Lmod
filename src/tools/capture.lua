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

-- $Id: capture.lua 118 2009-02-16 05:03:36Z mclay $ --

capture = nil
require("strict")

local Dbg   = require("Dbg")
local posix = require("posix")
function capturePOPEN(cmd,level)
   local dbg    = Dbg:dbg()
   level        = level or 1
   local level2 = level or 2
   dbg.start(level, "capture")
   dbg.print("cwd: ",posix.getcwd(),"\n")
   dbg.print("cmd: ",cmd,"\n")
   local p = io.popen(cmd)
   if p == nil then
      return nil
   end
   local ret = p:read("*all")
   p:close()
   dbg.start(level2,"capture output")
   dbg.print(ret)
   dbg.fini()
   dbg.fini()
   return ret
end

function captureFILE(cmd, level)
   local dbg    = Dbg:dbg()
   level        = level or 1
   local level2 = level or 2
   dbg.start(level,"captureFILE")
   dbg.print("cmd: ",cmd,"\n")
   local tmpName = os.tmpname()
   local cmd     = cmd .. " > " .. tmpName
   local results = nil
   os.execute(cmd)
   local f = io.open(tmpName)
   if (f) then
      results = f:read("*all")
      f:close()
      os.remove(tmpName)
      dbg.start(level2,"capture output")
      dbg.print(results)
      dbg.fini()
   end
   dbg.fini()
   return results
end

capture = capturePOPEN

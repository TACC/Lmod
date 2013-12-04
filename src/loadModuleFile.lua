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

require("strict")
require("fileOps")
require("sandbox")
require("string_split")
local dbg       = require("Dbg"):dbg()
local concatTbl = table.concat

------------------------------------------------------------------------
-- loadModuleFile(t): read a modulefile in via sandbox_run

function loadModuleFile(t)
   dbg.start("loadModuleFile()")
   dbg.print("t.file: ",t.file,"\n")
   dbg.flush()

   local full    = myModuleFullName()
   local usrName = myModuleUsrName()
   local myType  = extname(t.file)
   local func
   local msg
   local status = true
   local whole
   if (myType == ".lua") then
      -- Read in lua module file into a [[whole]] string.
      local f = io.open(t.file)
      if (f) then
         whole = f:read("*all")
         dbg.start("ModuleFile")
         dbg.print(whole)
         dbg.fini()
         f:close()
      end
   else
      -- Build argument list then call tcl2lua translator
      -- Capture results into [[whole]] string.
      local s      = t.mList or ""
      local A      = {}
      A[#A + 1]    = "-l"
      A[#A + 1]    = "\"" .. s .. "\"" 
      A[#A + 1]    = "-f"
      A[#A + 1]    = full
      A[#A + 1]    = "-u"
      A[#A + 1]    = usrName
      A[#A + 1]    = "-s"
      A[#A + 1]    = t.shell
      if (t.help) then
         A[#A + 1] = t.help
      end
      local a      = {}
      a[#a + 1]	   = pathJoin(cmdDir(),"tcl2lua.tcl")
      a[#a + 1]	   = concatTbl(A," ")
      a[#a + 1]	   = t.file
      local cmd    = concatTbl(a," ")
      whole        = capture(cmd) 
   end

   -- Use the sandbox to evaluate modulefile text.
   if (whole) then
      status, msg = sandbox_run(whole)
   else
      status = nil
      msg    = "Empty or non-existant file"
   end

   -- report any errors
   if (not status and t.reportErr) then
      local n = usrName or ""
      
      LmodError("Unable to load module: ",n,"\n    ",t.file,": ", msg,"\n")
   end
   dbg.fini("loadModuleFile")
end

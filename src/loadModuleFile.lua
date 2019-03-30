--------------------------------------------------------------------------
-- This module is the only file that actually reads and causes the
-- module file to be evaluated.  If the file name has a ".lua" extension
-- then it is a Lua modulefile.  Otherwise it is considered to be a TCL
-- modulefile.
-- @module loadModuleFile

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

require("strict")
require("myGlobals")
require("fileOps")
require("sandbox")
require("string_utils")
require("utils")
local dbg             = require("Dbg"):dbg()
local concatTbl       = table.concat
local getenv          = os.getenv

------------------------------------------------------------------------
-- loadModuleFile(t): read a modulefile in via sandbox_run
-- @param t The input table naming the file to be loaded plus other
--          things like the current list of modules and the shell.
function loadModuleFile(t)
   dbg.start{"loadModuleFile(",t.file,")"}

   local myType   = extname(t.file)
   local status   = true
   local func
   local msg
   local whole
   local userName 

   -- If the user is requesting an unload, don't complain if the file
   -- has disappeared.

   if (mode() == "unload" and not isFile(t.file)) then
      dbg.fini("loadModuleFile")
      return
   end

   if (myType == ".lua") then
      -- Read in lua module file into a [[whole]] string.
      local f = io.open(t.file)
      if (f) then
         whole = f:read("*all")
         dbg.start{"ModuleFile"}
         dbg.print{whole}
         dbg.fini("ModuleFile")
         f:close()
      end
   else
      userName       = myModuleUsrName()
      local fullName = myModuleFullName()
      -- Build argument list then call tcl2lua translator
      -- Capture results into [[whole]] string.
      local s      = t.mList or ""
      local A      = {}
      local mode   = mcp:tcl_mode()
      A[#A + 1]    = "-l"
      A[#A + 1]    = "\"" .. s .. "\""
      A[#A + 1]    = "-f"
      A[#A + 1]    = fullName
      A[#A + 1]    = "-m"
      A[#A + 1]    = mode
      A[#A + 1]    = "-u"
      A[#A + 1]    = userName
      A[#A + 1]    = "-s"
      A[#A + 1]    = t.shell
      
      local ldlib  = getenv("LD_LIBRARY_PATH")

      if (ldlib) then
         A[#A + 1]    = "-L"
         A[#A + 1]    = "\"" .. ldlib .. "\""
      end

      local ld_preload = getenv("LD_PRELOAD")

      if (ld_preload) then
         A[#A + 1]    = "-P"
         A[#A + 1]    = "\"" .. ld_preload .. "\""
      end
      
      if (t.help) then
         A[#A + 1] = "-h"
      end
      A[#A + 1] = path_regularize(t.file)
      whole, status = runTCLprog(pathJoin(cmdDir(),"tcl2lua.tcl"),concatTbl(A," "))
      if (not status) then
         local n = userName or ""
         msg     = "Non-zero status returned"
         LmodError{msg="e_Unable_2_Load", name = n, fn = t.file, message = msg}
      end
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
      local n = userName or ""
      LmodError{msg="e_Unable_2_Load", name = n, fn = t.file, message = msg}
   end

   dbg.fini("loadModuleFile")
end

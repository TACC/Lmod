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
require("string_utils")
local dbg = require("Dbg"):dbg()
function ModifyPath()
   dbg.start{"ModifyPath()"}
   local masterTbl   = masterTbl()
   local oldTarg     = os.getenv('TARG') or ''
   local targ        = masterTbl.envVarsTbl.TARG
   local targPathLoc = masterTbl.TargPathLoc or "empty"
   local path        = os.getenv('PATH') or ''

   local w_path      = ":" .. path    .. ":"
   local w_oldTarg   = ":" .. oldTarg .. ":"
   local w_targ      = ":" .. targ    .. ":"

   if (targ == "" or targPathLoc == "empty") then
      w_targ    = ":"
   end
   
   w_oldTarg = w_oldTarg:escape()

   if (w_oldTarg == '::' or w_path:find(w_oldTarg) == nil) then
      if (targPathLoc == "last") then
         path =  path .. w_targ
      else
         path = w_targ .. path
      end

      dbg.print{"(1) path: ",path,"\n"}
   else
      path = w_path:gsub(w_oldTarg,w_targ)
      dbg.print{"(2) path:",path,"\n"}
   end

   if (path:sub(1,1) == ':') then
      path = path:sub(2)
   end

   if (path:sub(-1,-1) == ':') then
      path = path:sub(1,-2)
   end

   masterTbl.envVarsTbl.PATH = path
   dbg.fini("ModifyPath")
end

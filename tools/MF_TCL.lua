--------------------------------------------------------------------------
-- This is a derived class from MF_Base.  This classes knows how
-- to expand the environment variables into TCL syntax.
-- @classmod MF_TCL

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

--------------------------------------------------------------------------
-- MF_TCL: This is a derived class from MF_Base.  This classes knows how
--          to expand the environment variables into TCL syntax.




local MF_TCL     = inheritsFrom(MF_Base)
local dbg        = require("Dbg"):dbg()
local concatTbl  = table.concat
MF_TCL.my_name   = "TCL"

--------------------------------------------------------------------------
-- generate string for setenv write in TCL.
-- @param self MF_Lua object
-- @param k key
-- @param v value
function MF_TCL.setenv(self, k, v)
   return "setenv ".. k .. " {" .. v .. "};"
end

--------------------------------------------------------------------------
-- generate string for prepend_path write in TCL.
-- @param self MF_Lua object
-- @param k key
-- @param v value
function MF_TCL.prepend_path(self, k, v)
   return "prepend-path ".. k .. " {" .. v .. "};"
end

--------------------------------------------------------------------------
-- generate string for append_path write in TCL.
-- @param self MF_Lua object
-- @param k key
-- @param v value

function MF_TCL.append_path(self, k, v)
   return "append-path ".. k .. " {" .. v .. "};"
end

function MF_TCL.header()
   return "#%Module"
end

return MF_TCL


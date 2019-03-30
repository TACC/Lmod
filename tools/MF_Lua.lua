--------------------------------------------------------------------------
-- This is a derived class from MF_Base.  This classes knows how
-- to expand the environment variables into Lua syntax.
-- @classmod MF_Lua

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



local MF_Lmod     = inheritsFrom(MF_Base)
local dbg         = require("Dbg"):dbg()
local concatTbl   = table.concat
MF_Lmod.my_name   = "Lmod"

--------------------------------------------------------------------------
-- generate string for setenv write in Lua.
-- @param self MF_Lua object
-- @param k key
-- @param v value
function MF_Lmod.setenv(self, k, v)
   return "setenv(" .. k:doubleQuoteString() .. "," .. v:doubleQuoteString() .. ")"
end

--------------------------------------------------------------------------
-- generate string for prepend_path write in Lua.
-- @param self MF_Lua object
-- @param k key
-- @param v value

function MF_Lmod.prepend_path(self, k, v)
   return "prepend_path(" .. k:doubleQuoteString() .. "," .. v:doubleQuoteString() .. ")"
end

--------------------------------------------------------------------------
-- generate string for append_path write in Lua.
-- @param self MF_Lua object
-- @param k key
-- @param v value

function MF_Lmod.append_path(self, k, v)
   return "append_path(" .. k:doubleQuoteString() .. "," .. v:doubleQuoteString() .. ")"
end

return MF_Lmod


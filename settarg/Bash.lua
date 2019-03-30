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
require("pairsByKeys")
local concat      = table.concat
Bash              = inheritsFrom(BaseShell)
Bash.my_name      = 'bash'

function Bash.expandVar(self, k, v)

   local lineA = {}
   if (v == '' or not v) then
      io.stdout:write("unset '",k,"';\n")
   else
      lineA[#lineA + 1] = k
      lineA[#lineA + 1] = "='"
      lineA[#lineA + 1] = v
      lineA[#lineA + 1] = "';\n"
      lineA[#lineA + 1] = "export "
      lineA[#lineA + 1] = k
      lineA[#lineA + 1] = ";\n"
      local line = concat(lineA,"")
      io.stdout:write(line)
   end
end

function Bash.unset(self, k)
   io.stdout:write("unset ",k,";\n")
end

return Bash

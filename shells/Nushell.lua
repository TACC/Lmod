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
-- Nushell: This is a derived class from BaseShell.  This class knows how
--          to expand environment variables into nushell syntax.


require("strict")


local BaseShell = require("BaseShell")
local Nushell   = inheritsFrom(BaseShell)
local dbg       = require("Dbg"):dbg()
local Var       = require("Var")
local concatTbl = table.concat
local stdout    = io.stdout
Nushell.my_name = "nushell"
Nushell.myType  = Nushell.my_name

--------------------------------------------------------------------------
-- Nushell:alias(): Either define or undefine a nushell alias.
--                  Modify module definition of alias so that there is
--                  one and only one semicolon at the end.

function Nushell.alias(self, k, v)
   if (not v) then
      -- Nushell doesn't have a direct unalias, set to nothing
      stdout:write("alias ",k," = $nothing\n")
      dbg.print{   "alias ",k," = $nothing\n"}
   else
      v = v:gsub(";%s*$","")
      stdout:write("alias ",k," = ",v,"\n")
      dbg.print{   "alias ",k," = ",v,"\n"}
   end
end

--------------------------------------------------------------------------
-- Nushell:shellFunc(): Either define or undefine a nushell custom command.
--                      Nushell uses custom commands instead of shell functions.

function Nushell.shellFunc(self, k, v)
   if (not v) then
      -- Cannot easily undefine custom commands in nushell, skip
      return
   else
      local func = v[1]:gsub(";%s*$","")
      stdout:write("def ",k," [] { ",func," }\n")
      dbg.print{   "def ",k," [] { ",func," }\n"}
   end
end


--------------------------------------------------------------------------
-- Nushell:expandVar(): Define environment variables in nushell syntax
--                      Use vType parameter to determine if variable is path-like

local s_quoteA = {
   {"r#'","'#"},
   {"r##'","'##"},
   {"r###'","'###"},
   {"r####'","'####"},
   {"r#####'","'#####"},
   {"r######'","'######"},
}

local function l_quoteValue(value)
   for i = 1,#s_quoteA do
      local left = s_quoteA[i][1]
      local rght = s_quoteA[i][2]
      if (not (value:find(left,1,true) or value:find(rght,1,true))) then
         return left, rght
      end
   end
   return s_quoteA[1][1], s_quoteA[1][2]
end




function Nushell.expandVar(self, k, v, vType)
   local lineA = {}
   v = tostring(v)
   
   -- Handle path-like variables by converting to nushell list format
   -- BUT: __LMOD_REF_COUNT_* variables are encoded strings, not actual paths
   if (vType == "path" and not k:match("^__LMOD_REF_COUNT_")) and k ~= "MODULEPATH" then
      lineA[#lineA + 1] = "$env."
      lineA[#lineA + 1] = k
      lineA[#lineA + 1] = " = ["
      
      -- Split on colons and create a nushell list
      local pathA  = path2pathA(v)
      local qpathA = nil

      if (k:match("^__LMOD_STACK_")) then
         qpathA = pathA
      else
         qpathA = {}
         for i = 1,#pathA do
            local path = pathA[i]
            local left, rght = l_quoteValue(path)
            qpathA[i] = left .. path .. rght
         end
      end

      lineA[#lineA + 1] = concatTbl(qpathA, ", ")
      lineA[#lineA + 1] = ",];\n"
   else
      -- Regular environment variable
      lineA[#lineA + 1] = "$env."
      lineA[#lineA + 1] = k
      lineA[#lineA + 1] = " = "
      local left, rght = l_quoteValue(v)
      lineA[#lineA + 1] = left .. v .. rght
      lineA[#lineA + 1] = ";\n"
   end
   
   local line = concatTbl(lineA,"")
   stdout:write(line)
   dbg.print{line}
end

--------------------------------------------------------------------------
-- Nushell:unset() unset an environment variable.

function Nushell.unset(self, k, vType)
   stdout:write("$env.",k," = $nothing\n")
   dbg.print{   "$env.",k," = $nothing\n"}
end


--------------------------------------------------------------------------
-- Nushell:real_shell(): Return true if the output shell is "real" or not.
--                       This base function returns false.  Bash, Csh
--                       and Fish should return true.

function Nushell.real_shell(self)
   return true
end

return Nushell 

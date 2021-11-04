-------------------------------------------------------------------------
-- This is a debug printing class.  The point is to add these debug print
-- statement permanently and use command line options to turn these print
-- stmts on when necessary.
--
-- Test code for using  Dbg.lua
--    require("strict")
--    local dbg = require("Dbg"):dbg()
--    function a()
--       dbg.start{2,"a"}
--       dbg.print{"In a","\n"}
--       b()
--       dbg.fini()
--    end
--
--    function b()
--       dbg.start{2,"b"}
--       dbg.print{"In b","\n"}
--       c()
--       dbg.fini()
--    end
--
--    function c()
--       dbg.start{3,"c"}
--       dbg.print{1,"In c","\n"}
--       dbg.fini()
--    end
--
--    function main()
--       local level = 10
--       dbg:activateDebug(level)
--
--       dbg.start{2,"main"}
--       a()
--       dbg.fini()
--    end
--
--    main()
--
-- @classmod Dbg

require("strict")

------------------------------------------------------------------------
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

local blank        = " "
local huge         = math.huge
local max          = math.max
local remove       = table.remove

local M = {}

s_dbg           = nil
s_warningCalled = false
s_indentString  = ""
s_indentLevel   = 0
s_vpl           = 1
s_currentLevel  = huge
s_levelA        = {}
s_isActive      = false
s_prefix        = ""
--local function l_prtTbl(a)
--   io.stderr:write("table:\n")
--   for _,v in ipairs(a) do
--      if (type(a) == "table") then
--	 l_prtTbl(v)
--      else
--	 io.stderr:write(v)
--      end
--   end
--end

--[[ rPrint(struct, [limit], [indent])   Recursively print arbitrary data.
Set limit (default 100) to stanch infinite loops.
Indents tables as [KEY] VALUE, nested tables as [KEY] [KEY]...[KEY] VALUE
Set indent ("") to prefix each line:    Mytable [KEY] [KEY]...[KEY] VALUE

Taken from https://gist.github.com/stuby/5445834
--]]
local function l_rPrint(s, l, i)
    -- recursive Print (structure, limit, indent)
    l = (l) or 100; i = i or "";	-- default item limit, indent string
    if (l<1) then io.stderr:write("ERROR: Item limit reached.", "\n"); return l-1 end;
    local ts = type(s);
    if (ts ~= "table") then
        io.stderr:write(i," ", tostring(ts), " ", tostring(s),"\n")
        return l-1
    end
    io.stderr:write(i," ", ts,"\n");  -- print "table"
    for k,v in pairs(s) do  -- print "[KEY] VALUE"
        l = l_rPrint(v, l, i.."\t["..tostring(k).."]");
        if (l < 0) then break end
    end
    return l
end

local function l_argsPack(...)
   local argA = { n = select("#", ...), ...}
   return argA
end
local pack        = (_VERSION == "Lua 5.1") and l_argsPack or table.pack -- luacheck: compat

local function l_changeIndentLevel(i)
   s_indentLevel  = s_indentLevel + i
   s_indentString = blank:rep(s_indentLevel*2)
end

local function l_new(self)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   o.print      = M._quiet
   o.printA     = M._quiet
   o.printT     = M._quiet
   o.textA      = M._quiet
   o.start      = M._quiet
   o.fini       = M._quiet
   o.warning    = M._warning
   o.error      = M._error
   o.quiet      = M._quiet
   o.indent     = M._zeroIndent
   o.is_active  = false
   return o
end

--------------------------------------------------------------------------
-- Singleton ctor for class
-- @param self Dbg object.
function M.dbg(self)
   if (s_dbg == nil) then
      s_dbg = l_new(self)
   end
   return s_dbg
end

--------------------------------------------------------------------------
-- Add a name (e.g. a program name) to the warning and error routines.
-- This is a class static function.
-- @param prefix the input name to prefix the error or warning message.
function M.set_prefix(prefix)
   s_prefix = prefix .. " "
end

--------------------------------------------------------------------------
-- Activate debug print statements.
-- @param self Dbg object.
-- @param[opt] level A zero means printing start and end of routines w/o prints
-- A one or greater include printing.
-- @param[opt] indentLevel indent level.  Mainly used when passing indent level
-- to a subprogram.
function M.activateDebug(self, level, indentLevel)
   level = tonumber(level) or 1
   if (level == 0) then
      self.start            = M._start
      self.fini             = M._fini
   elseif (level > 0) then
      self.print            = M._print
      self.printA           = M._printA
      self.printT           = M._printT
      self.textA            = M._textA
      self.start            = M._start
      self.fini             = M._fini
      self.indent           = M._indent
      s_isActive            = true
      s_currentLevel        = level
      s_levelA[#s_levelA+1] = level
      s_indentLevel         = tonumber(indentLevel) or s_indentLevel
      if (s_indentLevel > 0) then
         s_indentString     = blank:rep(s_indentLevel*2)
      end
   else
      self.print      = M._quiet
      self.printA     = M._quiet
      self.printT     = M._quiet
      self.textA      = M._quiet
      self.start      = M._quiet
      self.fini       = M._quiet
      self.warning    = M._warning
      self.error      = M._error
      self.quiet      = M._quiet
      self.indent     = M._zeroIndent
      self.is_active  = false
   end
end

--------------------------------------------------------------------------
-- Returns indent level
function M.indentLevel()
   return s_indentLevel
end

--------------------------------------------------------------------------
-- Returns is active flag
function M.active()
   return s_isActive
end

--------------------------------------------------------------------------
-- Returns current level
function M.currentLevel(level)
   s_currentLevel = level or 1
end

--------------------------------------------------------------------------
-- Deactivate Warings
function M.deactivateWarning(self)
   self.warning = M._quiet
end

--------------------------------------------------------------------------
-- Activate Warings
function M.activateWarning(self)
   self.warning = M._warning
end

--------------------------------------------------------------------------
-- Quiet function
function M._quiet()
end

--------------------------------------------------------------------------
-- extract the verbosity level
local function l_extractVPL(t)
   local vpl = t.level or s_vpl
   return vpl
end

local function l_startExtractVPL(t)
   local vpl = t.level or s_vpl
   s_levelA[#s_levelA+1] = vpl
   return vpl
end

--------------------------------------------------------------------------
-- Start of a routine
function M._start(t)
   s_vpl = l_startExtractVPL(t)
   if (s_vpl > s_currentLevel) then return end

   io.stderr:write(s_indentString)
   for i = 1, #t do
      io.stderr:write(tostring(t[i]))
   end
   io.stderr:write("{\n")
   l_changeIndentLevel(1)

end

--------------------------------------------------------------------------
-- Zero indent.

function M._zeroIndent()
   return ""
end

--------------------------------------------------------------------------
-- Return the current indent string.
function M._indent()
   return blank:rep(s_indentLevel*2)
end

--------------------------------------------------------------------------
-- End of a routine
function M._fini(s)
   local vpl = s_vpl

   if (vpl <= s_currentLevel) then
      s_indentLevel  = max(0, s_indentLevel - 1)
      s_indentString = blank:rep(s_indentLevel*2)
      if (s) then
         io.stderr:write(s_indentString,"} ",s,"\n")
      else
         io.stderr:write(s_indentString,"}\n")
      end
   end

   if (#s_levelA > 1) then
      remove(s_levelA)  -- remove last entry in table
   end
   s_vpl = s_levelA[#s_levelA]
end

--------------------------------------------------------------------------
-- Print a warning message and mark class static variable to remember that
-- a warning was called.
function M._warning(...)
   io.stderr:write("\n",s_prefix,"Warning: ")
   local argA = pack(...)
   for i = 1, argA.n do
      io.stderr:write(argA[i])
   end
   s_warningCalled = true
end

--------------------------------------------------------------------------
-- Print error message and quit.
function M._error(...)
   io.stderr:write("\n",s_prefix,"Error: ")
   local argA = pack(...)
   for i = 1, argA.n do
      io.stderr:write(argA[i])
   end
   io.stderr:write("\n")
   M.errorExit()
end


--------------------------------------------------------------------------
-- Error exit
function M.errorExit()
   io.stdout:write("false\n")
   os.exit(1)
end

--------------------------------------------------------------------------
-- Report true if a warning was called.
function M.warningCalled()
   return s_warningCalled
end

------------------------------------------------------------------------
-- The debug print statement
-- @param t input table.

function M._print(t)
   local vpl = l_extractVPL(t)
   if (vpl > s_currentLevel) then
      return
   end

   io.stderr:write(s_indentString)
   for i = 1, #t do
      local v = t[i]
      if (type(v) == "table") then
         l_rPrint(v, nil, s_indentString)
      else
         if (type(v) ~= "string") then
            v = tostring(v)
         elseif ( v == "") then
            v = "''"
         end

         local idx = v:find("\n")
         if (idx == nil or v:len() == idx) then
            io.stderr:write(v)
         else
            local s = v:sub(1,idx)
            io.stderr:write(s)
            M._print{v:sub(idx+1)}
         end
      end
   end
end


--------------------------------------------------------------------------
-- Write a indented text block.
-- @param t input string table array.  t.name is the string name t.a
-- is the array of strings.
function M._textA(t)
   local a  = t.a

   io.stderr:write(s_indentString)
   if (#a == 0) then
      io.stderr:write(t.name,": (empty)\n")
      return
   else
      io.stderr:write(t.name,":\n")
   end

   l_changeIndentLevel(1)
   for i = 1, #a do
      io.stderr:write(s_indentString, a[i])
   end
   l_changeIndentLevel(-1)
end

--------------------------------------------------------------------------
-- Print an array
-- @param t input array.
function M._printA(t)
   local a    = t.a
   if (type(a[1]) == "table") then
      M._print2D(t)
      return
   end

   io.stderr:write(s_indentString)
   io.stderr:write(t.name)

   for i = 1,#a do
      io.stderr:write(" \"",a[i],"\"")
   end
   io.stderr:write("\n")
end

--------------------------------------------------------------------------
-- Print 2d array.
-- @param t input 2-D array.
function M._print2D(t)
   local name = t.name
   local A    = t.a

   for j = 1,#A do
      io.stderr:write(s_indentString)
      io.stderr:write(name,"[",j,"]:")
      local a = A[j]
      for i = 1,#a do
         io.stderr:write(" ",a[i])
      end
      io.stderr:write("\n")
   end
end

--------------------------------------------------------------------------
-- flush the output to stderr.
function M.flush()
   io.stderr:flush()
end

function M._printT(name, value)
   require("serializeTbl")
   io.stderr:write(serializeTbl{indent=s_indentString, name = name, value=value})
end

---- finis -----
return M

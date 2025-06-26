--------------------------------------------------------------------------
-- This collection of routines are used to convert a table into a string.
-- This string is valid lua code. Note that this will only work for "DAG"
-- and not loops. There are more general solutions available but the
-- output less attractive.  Since Lmod tables are DAG's this works fine.
--
-- Typical usage:
--   Write to a file:
--      serializeTbl{indent=true, name="SomeName", value=luaTable,
--                   fn = "/path/to/file"}
--   Generate String:
--      s = serializeTbl{indent=true, name="SomeName", value=luaTable}
--
--   Note that indent can also be an indent string (i.e. indent = "    ")
--   which will be treated as the initial indentation.

-- @module serializeTbl

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

require("fileOps")
require("pairsByKeys")
require("TermWidth")

--------------------------------------------------------------------------
-- Convert the string value into a quoted string of some kind and boolean
-- into true/false.

local quoteA = {
   {'[[',']]'},
   {'[=[',']=]'},
   {'[==[',']==]'},
   {'[===[',']===]'},
   {'[====[',']====]'},
   {'[=====[',']=====]'},
   {'[======[',']======]'},
   {'[=======[',']=======]'},
   {'[========[',']========]'},
}
   
local s_equal
local s_nl
local s_comma

local function l_set_constants(kind)
   if (kind == "tight") then
      s_equal = "="
      s_nl    = ""
      s_comma = ","
   else
      s_equal = " = "
      s_nl    = "\n"
      s_comma = ", "
   end
end

local function l_quoteValue(value)
   for i = 1,#quoteA do
      local left = quoteA[i][1]
      local rght = quoteA[i][2]
      if (not (value:find(left,1,true) or value:find(rght,1,true))) then
         return left, rght
      end
   end
   return quoteA[1][1], quoteA[1][2]
end


local function l_nsformat(value, dsplyNum)
   if (type(value) == 'string') then
      if ( value:find('[\n"]') ) then
         local left, rght = l_quoteValue(value)
	 value = left .. value .. rght
      else
	 value = "\"" .. value .. "\""
      end
   elseif (type(value) == 'boolean') then
      if (value) then
	 value = 'true'
      else
	 value = 'false'
      end
   elseif (type(value) == 'number') then
      value = tostring(value)
      if (dsplyNum == "string") then
         value = "\"" .. value .. "\""
      end
   end
   return value
end

local keywordT = {
   ['and']    = true,  ['break']  = true,    ['do']       = true,
   ['else']   = true,  ['elseif'] = true,    ['end']      = true,
   ['false']  = true,  ['for']    = true,    ['function'] = true,
   ['if']     = true,  ['in']     = true,    ['local']    = true,
   ['nil']    = true,  ['not']    = true,    ['or']       = true,
   ['repeat'] = true,  ['return'] = true,    ['then']     = true,
   ['true']   = true,  ['until']  = true,    ['while']    = true,
   ['']       = true,  [' ']      = true,
}

local function l_wrap_name(indent, name)
   local str
   if (name:find("[^0-9A-Za-z_]") or keywordT[name] or
       name:sub(1,1):find("[0-9]") ) then
      str = indent .. "[\"" .. name .. "\"]"
   else
      str = indent .. name
   end
   return str
end


--------------------------------------------------------------------------
-- This is the work-horse for this collections.  It is recursively for
-- sub-tables.  It also ignores keys that start with "__" unless
-- keepDUnderScore is true.

local function outputTblHelper(indentIdx, name, T, dsplyNum,
                               keepDUnderScore, ignoreKeysT, a, level)

   -------------------------------------------------
   -- Remove all keys in table that start with "__"

   local t = {}
   for key in pairs(T) do
      if (not ignoreKeysT[key] and (type(key) == "number" or keepDUnderScore or key:sub(1,2) ~= '__')) then
         t[key] = T[key]
      end
   end

   --------------------------------------------------
   -- Set initial indent

   local indent = ''
   if (indentIdx > 0) then
      indent = string.rep(" ",indentIdx)
   end

   --------------------------------------------------
   -- Form name: Wrap name in [] if it has special
   -- characters or it start with a number.
   local str
   if (type(name) == 'string') then
      str = l_wrap_name(indent, name) .. s_equal .. "{"
   else
      str = indent .. "{"
   end
   a[#a+1] = str
   if (next(T) == nil) then
      if (level == 0) then
         a[#a+1] = '}' .. s_nl
      else
         a[#a+1] = "}," .. s_nl
      end
      return
   end
   a[#a] = a[#a] .. s_nl

   --------------------------------------------------
   -- Update indent
   local origIndentIdx = indentIdx
   local origIndent    = indent
   if (indentIdx >= 0) then
      indentIdx = indentIdx + 2
      indent    = string.rep(" ",indentIdx)
   end


   -- verify if is an array with no tables in it.
   local isArray = true
   for key, value in pairs(t) do
      if (type(value) == "table" or type(key) == "string") then
         isArray = false
         break
      end
   end

   local twidth = TermWidth()
   local w      = 0
   if (isArray) then
      a[#a+1] = indent
      w       = w + indent:len()
      for i = 1,#t-1 do
         a[#a+1] = l_nsformat(t[i], dsplyNum)
         w       = w + tostring(a[#a]):len()
         a[#a+1] = s_comma
         w       = w + a[#a]:len()
         if ( w > twidth) then
            table.insert(a,#a-2, s_nl .. indent)
            w       = a[#a-1]:len()+2+indent:len()
         end
      end
      if (#t > 0) then
         a[#a+1] = l_nsformat(t[#t], dsplyNum)
         a[#a+1] = "," .. s_nl
      end
   else
      for key, value in pairsByKeys(t) do
         if (type(value) == 'table') then
            outputTblHelper(indentIdx, key, t[key], dsplyNum, keepDUnderScore, ignoreKeysT, a, level+1)
         else
            if (type(key) == "string") then
               str = l_wrap_name(indent, key) .. s_equal
            else
               str = indent
            end
            a[#a+1] = str
            a[#a+1] = l_nsformat(t[key], dsplyNum)
            a[#a+1] = "," .. s_nl
         end
      end
   end
   indent    = origIndent
   indentIdx = origIndentIdx
   if (level == 0) then
      a[#a+1] = indent .. '}' .. s_nl
   else
      a[#a+1] = indent .. "}," .. s_nl
   end
end

--------------------------------------------------------------------------
-- The interface routine for this file.  Note that it returns a string
-- if no file name is given.
-- @param options input table.
function serializeTbl(options)
   local a               = {}
   local tight           = options.tight    or "normal"
   local dsplyNum        = options.dsplyNum or "normal"
   local n               = options.name
   local level           = 0
   local value           = options.value
   local keepDUnderScore = options.keep_double_underscore
   local ignoreKeysT     = options.ignoreKeysT or {}
   local indentIdx       = -1

   l_set_constants(tight)

   if (options.indent) then
      indentIdx = 0
      if (type(options.indent) == 'string' and options.indent:find("^  *$")) then
         indentIdx = options.indent:len()
      end
   end


   if (type(value) == "table") then
      outputTblHelper(indentIdx, options.name, options.value, dsplyNum,
                      keepDUnderScore, ignoreKeysT, a, level)
   else
      a[#a+1] = l_wrap_name("",n)
      a[#a+1] = s_equal
      a[#a+1] = l_nsformat(value, dsplyNum)
      a[#a+1] = s_nl
   end

   local s = table.concat(a,"")
   s = s:gsub(", *}","}")

   if (options.fn == nil) then
      return s
   end

   local fn = options.fn
   local d  = dirname(fn)
   if (not isDir(d)) then
      os.execute('mkdir -p ' .. d)
   end
   local f  = assert(io.open(fn, "w"))

   f:write("-- -*- lua -*-\n")
   f:write("-- created: ",os.date()," --\n")
   f:write(s)
   f:close()
end

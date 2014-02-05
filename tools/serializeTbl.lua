------------------------------------------------------------------------
--
--  Copyright (C) 2008-2014 Robert McLay
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
-- serializeTbl: This collection of routines are used to convert a
--               table into a string.  This string is valid lua code.
--               Note that this will only work for "DAG" and not loops.
--               There are more general solutions available but the
--               output less attractive.  Since Lmod tables are DAG's
--               this works fine.
--
-- Typical usage:
--   Write to a file:
--      serializeTbl{indent=true, name="SomeName", value=luaTable,
--                   fn = "/path/to/file"}
--   Generate String:
--      s = serializeTbl{indent=true, name="SomeName", value=luaTable}
--
require("strict")
require("fileOps")
require("pairsByKeys")
require("TermWidth")

--------------------------------------------------------------------------
-- nsformat(): Convert the string value into a quoted string of some kind
--             and boolean into true/false.

local function nsformat(value)
   if (type(value) == 'string') then
      if (value:find("\n")) then
	 value = "[[\n" .. value .. "\n]]"
      else
         value = value:gsub('"','\\"')
	 value = "\"" .. value .. "\""
      end
   elseif (type(value) == 'boolean') then
      if (value) then
	 value = 'true'
      else
	 value = 'false'
      end
   end
   return value
end

--------------------------------------------------------------------------
-- outputTblHelper():  This is the work-horse for this collections.  It is
--                     used recursively for subtables.  It also ignores
--                     keys that start with "_".

local function outputTblHelper(indentIdx, name, T, a, level)

   -------------------------------------------------
   -- Remove all keys in table that start with "_"

   local t = {}
   for key in pairs(T) do
      if (type(key) == "number" or key:sub(1,1) ~= '_') then
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
      if (name:find("[-+:./]") or name == "local" or name == "nil" or
          name:sub(1,1):find("[0-9]")) then
	 str = indent .. "[\"" .. name .. "\"] = {\n"
      else
	 str = indent .. name .. " = {\n"
      end
   else
      str = indent .. "{\n"
   end
   a[#a+1] = str

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
         a[#a+1] = nsformat(t[i])
         w       = w + a[#a]:len()
         a[#a+1] = ", "
         w       = w + a[#a]:len()
         if ( w > twidth) then
            table.insert(a,#a-2,"\n" .. indent)
            w       = a[#a-1]:len()+2+indent:len()
         end
      end
      if (#t > 0) then
         a[#a+1] = nsformat(t[#t])
         a[#a+1] = ",\n"
      end
   else
      for key, value in pairsByKeys(t) do
         if (type(value) == 'table') then
            outputTblHelper(indentIdx, key, t[key], a, level+1)
         else
            if (type(key) == "string") then
               str = indent .. '[\"'..key ..'\"] = '
            else
               str = indent
            end
            a[#a+1] = str
            a[#a+1] = nsformat(t[key])
            a[#a+1] = ",\n"
         end
      end
   end
   indent    = origIndent
   indentIdx = origIndentIdx
   if (level == 0) then
      a[#a+1] = indent .. '}\n'
   else
      a[#a+1] = indent .. "},\n"
   end
end

--------------------------------------------------------------------------
-- serializeTbl(): The interface routine for this file.  Note that
--                 it returns a string if no file name is given.

function serializeTbl(options)
   local a         = {}
   local n         = options.name
   local level     = 0
   local value     = options.value
   local indentIdx = -1
   if (options.indent) then
      indentIdx = 0
   end

   if (type(value) == "table") then
      outputTblHelper(indentIdx, options.name, options.value, a, level)
   else
      a[#a+1] = n
      a[#a+1] = " = "
      a[#a+1] = nsformat(value)
      a[#a+1] = "\n"
   end

   local s = table.concat(a,"")

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

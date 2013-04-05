require("strict")
require("fileOps")
require("pairsByKeys")

local function nsformat(value)
   if (type(value) == 'string') then
      if (string.find(value,"\n")) then
	 value = "[[\n" .. value .. "\n]]"
      else
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
      
   for key, value in pairsByKeys(t) do
      if (type(t[key]) == 'table') then
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
   indent    = origIndent
   indentIdx = origIndentIdx
   if (level == 0) then
      a[#a+1] = indent .. '}\n'
   else
      a[#a+1] = indent .. "},\n"
   end
end

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

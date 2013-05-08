--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lua is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2013 Robert McLay
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
require("string_trim")
require("string_split")
local posix = require("posix")
local lfs   = require("lfs")

local concatTbl = table.concat

function findInPath(exec, path)
   local result  = ""

   if ( exec == nil) then return result end

   if (exec:find("/")) then
      if (posix.access(exec,"x")) then
         return exec
      else
         return result
      end
   end

   path    = path or os.getenv("PATH")
   for dir in path:split(":") do
      local cmd = pathJoin(dir, exec)
      if (posix.access(cmd,"x")) then
         result = cmd
         break
      end
   end
   return result
end

function isDir(d)
   if (d == nil) then return false end
   local t = posix.stat(d,"type")

   local result = (t == "directory")

   return result
end

function isFile(fn)
   if (fn == nil) then return false end
   local t = posix.stat(fn,"type")

   local result = ((t == "regular") or (t == "link"))

   return result
end

function isExec(fn)
   if (fn == nil) then return false end
   local result = posix.access(fn,"rx")
   return result
end


function dirname(path)
   if (path == nil) then return nil end
   local result
   local i,j = path:find(".*/")
   if (i == nil) then
      result = "./"
   else
      result = path:sub(1,j)
   end
   return result
end

function extname(path)
   if (path == nil) then return nil end
   local result
   local i,j = path:find(".*/")
   i,j       = path:find(".*%.",j)
   if (i == nil) then
      result = ""
   else
      result = path:sub(j,-1)
   end
   return result
end

function removeExt(path)
   if (path == nil) then return nil end
   local result
   local i,j = path:find(".*/")
   i,j       = path:find(".*%.",j)
   if (i == nil) then
      result = path
   else
      result = path:sub(1,j-1)
   end
   return result
end

function barefilename(path)
   if (path == nil) then return nil end
   local result
   local i,j = path:find(".*/")
   if (i == nil) then
      result = path
   else
      result = path:sub(j+1,-1)
   end
   return result
end

function splitFileName(path)
   if (path == nil) then return nil, nil end
   local d, f
   local i,j = path:find(".*/")
   if (i == nil) then
      d = './'
      f = path
   else
      d = path:sub(1,j)
      f = path:sub(j+1,-1)
   end
   return d, f
end

function pathJoin(...)
   local a = {}
   local arg = { n = select('#', ...), ...}
   for i = 1, arg.n  do
      local v = arg[i]
      if (v and v ~= '') then
         local vType = type(v)
         if (vType ~= "string") then
            msg = "bad argument #" .. i .." (string expected, got " .. vType .. " instead)\n"
            assert(vType ~= "string", msg)
         end
      	 v = v:trim()
      	 if (v:sub(1,1) == '/' and i > 1) then
	    if (v:len() > 1) then
	       v = v:sub(2,-1)
	    else
	       v = ''
	    end
      	 end
      	 v = v:gsub('//+','/')
      	 if (v:sub(-1,-1) == '/') then
	    if (v:len() > 1) then
	       v = v:sub(1,-2)
	    elseif (i == 1) then
	       v = '/'
      	    else
	       v = ''
	    end
      	 end
      	 if (v:len() > 0) then
	    a[#a + 1] = v
	 end
      end
   end
   local s = concatTbl(a,"/")
   s = path_regularize(s)
   return s
end

function mkdir_recursive(path)
   local absolute
   if (path:sub(1,1) == '/') then
      absolute = true
      path = path:sub(2,-1)
   end

   local a = {}
   if (absolute) then
      a[#a + 1] = "/"
   end
   local d
   for v in path:split('/') do
      a[#a + 1] = v
      d         = concatTbl(a,'/')
      if (not isDir(d)) then
         lfs.mkdir(d)
      end
   end
end

function abspath (path, localDir)
   if (path == nil) then return nil end
   local cwd = lfs.currentdir()
   path = path:trim()

   if (path:sub(1,1) ~= '/') then
      path = pathJoin(cwd,path)
   end

   local dir    = dirname(path)
   local ival   = lfs.chdir(dir)

   path = pathJoin(lfs.currentdir(), barefilename(path))
   local result = path

   local attr = lfs.symlinkattributes(path)
   if (attr == nil) then
      lfs.chdir(cwd)
      return nil
   elseif (attr.mode == "link") then
      local rl = posix.readlink(path)
      if (not rl) then
         lfs.chdir(cwd)
         return nil
      end
      if (localDir and (rl:sub(1,1) == "/" or rl:sub(1,3) == "../")) then
         lfs.chdir(cwd)
         return result
      end
      result = abspath(rl, localDir)
   end
   lfs.chdir(cwd)
   return result
end

function path_regularize(value)
   if value == nil then return nil end
   value = value:gsub("^%s+","")
   value = value:gsub("%s+$","")
   value = value:gsub("//+","/")
   value = value:gsub("/%./","/")
   value = value:gsub("/$","")
   if (value == '') then
      value = ' '
   end
   return value
end

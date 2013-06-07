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

local unpack = unpack or table.unpack
local M = {}

s_KeyA = { 'display_name',
           'help',
           'keywords',
           'URL'
           'category',
           'description'
}
           
SITE_PACKAGE_ROOT = os.getenv("SITE_PACKAGE_ROOT") or "/opt/apps"

function M.new(self, t)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   for k, v in pairs(t) do
      o[k] = v
   end


   local pkgName    = myModuleName()
   local pkgVersion = myModuleVersion()
   local pkgNameVer = myModuleFullName()
   o._pkgName       = pkgName
   o._pkgVersion    = pkgVersion
   o._pkgNameVer    = pkgNameVer
   o._display_name  = o.display_name or pkgName
   
   local level      = o.level or 0

   local a          = {}
   a[#a+1]          = SITE_PACKAGE_ROOT
   if (level > 0) then
      local hierA   = hierarchyA(pkgNameVer,level)
  
      for i = 1, level do
         a[#a+1]    = hierA[i]:gsub("/","-"):gsub("%.","_")
      end
   end
   a[#a+1]          = pkgNameVer

   local base       = pathJoin(unpack(a))
   o._pkgBase       = base

   return o
end
   
function M.pkgName(self)
   return self._pkgName
end

function M.pkgDisplayName(self)
   return self._display_Name
end

function M.pkgVersion(self)
   return self._pkgName
end

function M.pkgBase(self)
   return self._pkgBase
end

function M.setPkgInfo(self)
   whatis("Name: "    .. self.pkgDisplayName())
   whatis("Version: " .. self.pkgVersion())

   local keyA = {"Category", "Description", "URL", "Keywords", "License"}
   
   for i = 1, #keyA do
      local k = keyA[i]
      local v = self[k]
      if (v and type(v) == "string") then
         whatis(k .. ": "..v)
      end
   end

   if (self.help) then
      help(self.help)
   end
end


return M

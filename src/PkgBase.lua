--------------------------------------------------------------------------
-- Fixme
-- @classmod PkgBase

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

require("strict")
require("inherits")
require("utils")
local M    = {}
local dbg  = require("Dbg"):dbg()
local hook = require("Hook")

function M.build(name)
   local pkg = require(name)
   return pkg:create()
end

function M.pkgBaseName(self)
   return "PkgBase"
end

s_MdirA = { [0] = "Compiler",
            [1] = "MPI",
}

SITE_PACKAGE_ROOT = os.getenv("SITE_PACKAGE_ROOT") or "/opt/apps"

function M.new(self, t)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   dbg.start{"PkgBase:new()"}
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
   o._pkgRoot       = o.pkgRoot or SITE_PACKAGE_ROOT

   local level      = o.level or 0

   local a          = {}
   a[#a+1]          = o._pkgRoot

   o._pkgBase       = o:_build_pkgBase(level)
   o:setPkgInfo()
   dbg.fini("PkgBase:new")
   return o
end

function M.setPkgInfo(self)
   dbg.start{"PkgBase:setPkgInfo()"}
   whatis("Name: "    .. self:pkgDisplayName())
   whatis("Version: " .. self:pkgVersion())

   local keyA = {"Category", "Description", "URL", "Keywords", "License"}

   for i = 1, #keyA do
      local k = keyA[i]
      local v = self[k]
      if (v and type(v) == "string") then
         whatis(k .. ": "..v)
      end
   end

   local helpMsg = self.help
   if (helpMsg) then
      local version = "\nVersion " .. self:pkgVersion() .. "\n"
      help(helpMsg, version)
   end
   dbg.fini("PkgBase:setPkgInfo")
end

local stdT = { DIR = "", BIN = "bin", LIB = "lib",
               INC = "include", DOC="doc",
               MAN = "man",
}


function M.setStandardPaths(self, ...)
   dbg.start{"PkgBase:setStandardPaths()"}
   local siteName = hook.apply("SiteName"):upper()
   local base     = self:pkgBase()
   local pkgNameU = self:pkgDisplayName():upper()
   local argA     = pack(...)


   for i = 1, argA.n do
      local v  = argA[i]:upper()
      local pp = stdT[v]             -- Path piece
      if (pp == nil) then
         LmodError{msg="e_setStandardPaths", key = argA[i]}
      end

      local name = siteName .. "_" .. pkgNameU .. "_" .. v
      local path = pathJoin(base, pp)
      setenv(name, path)

      if (v == "BIN") then
         prepend_path("PATH", path)
      end

      if (v == "MAN") then
         prepend_path("MANPATH", path)
      end


   end
   dbg.fini("PkgBase:setStandardPaths")
end

function M.pkgName(self)
   return self._pkgName
end

function M.pkgDisplayName(self)
   return self._display_name
end

function M.pkgVersion(self)
   return self._pkgVersion
end

function M.pkgBase(self)
   return self._pkgBase
end

return M

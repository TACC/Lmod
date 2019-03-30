--------------------------------------------------------------------------
-- Fixme
-- @classmod Pkg

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

Pkg = inheritsFrom(PkgBase)

local concatTbl = table.concat
local unpack    = (_VERSION == "Lua 5.1") and unpack or table.unpack -- luacheck: compat
local dbg       = require("Dbg"):dbg()
local M         = Pkg

s_MdirA = { [0] = "Compiler",
            [1] = "MPI",
}

function M.name(self)
   return "Pkg"
end

function M._build_pkgBase(self,level)
   dbg.start{"Pkg:_build_pkgBase()"}
   local pkgNameVer = self._pkgNameVer
   local pkgRoot    = self._pkgRoot
   local a          = {}
   a[#a+1]          = pkgRoot
   if (level > 0) then
      local hierA   = hierarchyA(pkgNameVer,level)

      for i = level,1,-1 do
         a[#a+1]    = hierA[i]:gsub("/","-"):gsub("%.","_")
      end
   end
   a[#a+1] = pkgNameVer
   dbg.fini("Pkg:_build_pkgBase")
   return pathJoin(unpack(a))
end

local function l_digit_rule_pattern(digit_rule)
   local sA = {}
   sA[#sA + 1] = "("

   for i = 1,digit_rule-1 do
      sA[#sA + 1] = "%d+%."
   end
   sA[#sA + 1] = "%d+)%.?"
   return concatTbl(sA,"")
end

function M.moduleDir(self)
   dbg.start{"Pkg:moduleDir()"}
   local level      = self.level or 0
   local digit_rule = self.digit_rule or 2
   local a          = {}
   a[#a+1]          = os.getenv("MODULEPATH_ROOT")
   a[#a+1]          = s_MdirA[level]

   if (level > 0) then
      local hierA = hierarchyA(self._pkgNameVer, level)
      for i = level, 1, -1 do
         a[#a+1] = hierA[i]
      end
   end

   local patt = l_digit_rule_pattern(digit_rule)
   local pkgV = self._pkgVersion:match(patt)

   a[#a+1]    = pathJoin(self._pkgName,pkgV)
   local mdir = pathJoin(unpack(a))

   dbg.fini("Pkg:moduleDir")
   return mdir
end

return M

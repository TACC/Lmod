--------------------------------------------------------------------------
-- Fixme
-- @module StandardPackage

_G._DEBUG       = false               -- Required by the new lua posix
local posix     = require("posix")

require("strict")
--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lmod is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ------------------------------------------------------------------------
--
--  Copyright (C) 2008-2018 Robert McLay
--
--  Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:
--
--  The above copyright notice and this permission notice shall be included in
--  all copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--  THE SOFTWARE.
--
--------------------------------------------------------------------------

require("TermWidth")
require("string_utils")
require("fileOps")
require("sandbox")
PkgBase         = require("PkgBase")
Pkg             = PkgBase.build("Pkg")
local concatTbl = table.concat
local cosmic    = require("Cosmic"):singleton()
local hook      = require("Hook")
local getenv    = os.getenv
local i18n      = require("i18n")
local min       = math.min

------------------------------------------------------------
-- Standard version of site_name_hook:
-- The default return LMOD unless it is overwritten by a site
-- setting LMOD_SITE_NAME.  

local function site_name_hook()
   return cosmic:value("LMOD_SITE_NAME") or "LMOD"
end

hook.register("SiteName",site_name_hook)

------------------------------------------------------------
-- Standard version of msg

local function msg(kind, a)
   local twidth = TermWidth()

   local s      = i18n(kind,{}) or ""
   if (s:len() > 0) then
      for line in s:split("\n") do
         a[#a+1] = "\n"
         a[#a+1] = line:fillWords("",twidth)
      end
      a[#a+1] = "\n"
   end
   a[#a+1] = "\n"
   return a
end

hook.register("msgHook",msg)

------------------------------------------------------------
-- Standard version of groupName

local function groupName(fn)
   local base  = removeExt(fn)
   local ext   = extname(fn)
   local sname = cosmic:value("LMOD_SYSTEM_NAME")

   if (sname) then
      sname = sname .."_"
   else
      sname = ""
   end

   local a    = {}
   a[#a + 1]  = base
   a[#a + 1]  = "."
   a[#a + 1]  = sname
   a[#a + 1]  = posix.uname("%m")
   a[#a + 1]  = '_'
   a[#a + 1]  = posix.uname("%s")
   a[#a + 1]  = ext
   return concatTbl(a,"")
end

hook.register("groupName",groupName)

sandbox_registration { Pkg = Pkg }

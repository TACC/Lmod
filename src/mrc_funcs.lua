--------------------------------------------------------------------------
-- .modulerc.lua files  are "loaded" in a sandbox.  That is when this file
-- is evaluated, it can only run a limited set of functions.
-- This file provides for a default list of functions that can be
-- run.  There is also a sandbox_registration so that sites using
-- SitePackage can register their functions. Finally there are two
-- versions of run function one for Lua 5.1 and another for Lua 5.2
-- The appropriate version is assigned to [[mrc_sandbox_run]].
--
-- @module mrc_sandbox

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

--module_version("module_name","v1","v2"...)
function module_version(module_name, ...)
   local argA = pack(...)
   ModA[#ModA+1] = {kind="module_version", module_name=module_name, module_versionA=argA}
end

--module_alias("name","modulefile")
function module_alias(name,mfile)
   ModA[#ModA+1] = {kind="module_alias", name=name, mfile=mfile}
end

--hide_version("full_module_version")
function hide_version(full)
   ModA[#ModA+1] = {kind="hide_version", mfile=full}
end


--hide_modulefile("/path/to/modulefile")
function hide_modulefile(path)
   ModA[#ModA+1] = {kind="hide_modulefile", mfile=path}
end


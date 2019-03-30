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

mrc_sandbox_run = false

require("mrc_funcs")
require("fileOps")
--------------------------------------------------------------------------
-- Table containing valid functions for modulefiles.
local mrc_sandbox_env = {
   module_alias    = module_alias,
   module_version  = module_version,
   hide_version    = hide_version,
   hide_modulefile = hide_modulefile,
   os              = { clock = os.clock, difftime = os.difftime, time = os.time, date = os.date,
                       getenv = os.getenv, execute = os.execute},
   io              = { stderr = io.stderr, open = io.open, close = io.close, write = io.write },
   ------------------------------------------------------------
   -- fileOp functions
   ------------------------------------------------------------
   pathJoin        = pathJoin,
   isDir           = isDir,
   isFile          = isFile,
}


--------------------------------------------------------------------------
-- This function is what actually "loads" a modulefile with protection
-- against modulefiles call functions they shouldn't or syntax errors
-- of any kind.
-- @param untrusted_code A string containing lua code

local function mrc_run5_1(untrusted_code)
  if untrusted_code:byte(1) == 27 then return nil, "binary bytecode prohibited" end
  local untrusted_function, message = loadstring(untrusted_code)
  if not untrusted_function then return nil, message end
  setfenv(untrusted_function, mrc_sandbox_env)
  return pcall(untrusted_function)
end

--------------------------------------------------------------------------
-- This function is what actually "loads" a modulefile with protection
-- against modulefiles call functions they shouldn't or syntax errors
-- of any kind. This run codes under environment [Lua 5.2] or later.
-- @param untrusted_code A string containing lua code
local function mrc_run5_2(untrusted_code)
  local untrusted_function, message = load(untrusted_code, nil, 't', mrc_sandbox_env)
  if not untrusted_function then return nil, message end
  return pcall(untrusted_function)
end

--------------------------------------------------------------------------
-- Define two version: Lua 5.1 or 5.2.  It is likely that
-- The 5.2 version will be good for many new versions of
-- Lua but time will only tell.
mrc_sandbox_run = (_VERSION == "Lua 5.1") and mrc_run5_1 or mrc_run5_2

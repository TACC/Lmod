--------------------------------------------------------------------------
-- This module controls the pager. There are two ways to use the pager.
-- If stderr is connected to a term and it is configured for it, stderr
-- will be run through the pager.  If not bypassPager is used which just
-- writes all strings to the stream "f".
-- @module pager

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

require("myGlobals")
require("haveTermSupport")

local dbg       = require("Dbg"):dbg()
local concatTbl = table.concat
local cosmic    = require("Cosmic"):singleton()

local function argsPack(...)
   local  argA = { n = select("#", ...), ...}
   return argA
end

local pack        = (_VERSION == "Lua 5.1") and argsPack or table.pack -- luacheck: compat

s_pager = false


--------------------------------------------------------------------------
-- All input arguments to stream f
-- @param f A stream object.
function bypassPager(f, ...)
   local argA = pack(...)
   for i = 1, argA.n do
      f:write(argA[i])
   end
end

--------------------------------------------------------------------------
-- Use pager to present input arguments to user via whatever
-- pager has been chosen.
-- @param f A stream object.
function usePager(f, ...)
   dbg.start{"usePager()"}
   s_pager = "LESS="..cosmic:value("LMOD_PAGER_OPTS").." "..s_pager
   local p = io.popen(s_pager .. " 1>&2" ,"w")
   local s = concatTbl({...},"")
   p:write(s)
   p:close()
   dbg.fini()
end

--------------------------------------------------------------------------
-- Return usePager if PAGER exists otherwise,  return bypassPager
function buildPager()
   local func  = bypassPager
   local pager = cosmic:value("LMOD_PAGER")
   s_pager     = find_exec_path(pager)
   if (s_pager) then
      func     = usePager
   end
   return func
end

pager = bypassPager

if (connected2Term()) then
   pager = buildPager()
end

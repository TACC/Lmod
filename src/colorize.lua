--------------------------------------------------------------------------
-- This module provides two functions.  One implements colorizing the
-- string and the other produces a plain string.
-- @module colorize

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
--  Copyright (C) 2008-2025 Robert McLay
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
require("utils")
require("haveTermSupport")
require("myGlobals")

local Escape  = "\027"
local FcolorT = {
   black      = "[1;30",
   red        = "[1;31",
   green      = "[1;32",
   yellow     = "[1;33",
   blue       = "[1;34",
   magenta    = "[1;35",
   cyan       = "[1;36",
   white      = "[1;37",
   none       = "[0",
}

local BcolorT = {
   black      = "[1;40",
   red        = "[1;41",
   green      = "[1;42",
   yellow     = "[1;43",
   blue       = "[1;44",
   magenta    = "[1;45",
   cyan       = "[1;46",
   white      = "[1;47",
   none       = "[0",
}
local cosmic    = require("Cosmic"):singleton()
local concatTbl = table.concat
local pack      = (_VERSION == "Lua 5.1") and argsPack or table.pack
local s_colorize_kind = "unknown"

------------------------------------------------------------------------
-- Takes an array of strings and wraps the ANSI color start and
-- stop and produces a single string.
-- @param color The key name for the *colorT* hash table.
function full_colorize(color, ... )
   local argA         = pack(...)
   local hiddenItalic = cosmic:value("LMOD_HIDDEN_ITALIC")
   if (not color or argA.n < 1) then
      return plain(color, ...)
   end

   local hiddenFore = (hiddenItalic == "yes") and "[3" or "[2"
   local cT = {
      hidden      = { fore = hiddenFore,        back = false},
      forbid      = { fore = FcolorT["yellow"], back = BcolorT["red"]},
      nearly      = { fore = FcolorT["red"],    back = BcolorT["yellow"]},
   }
   local fore = FcolorT[color] or cT[color].fore
   local back = cT[color] and cT[color].back or false

   local a = {}
   a[#a+1] = Escape
   a[#a+1] = fore
   a[#a+1] = "m"
   if (back) then
      a[#a+1] = Escape
      a[#a+1] = back
      a[#a+1] = "m"
   end
   for i = 1, argA.n do
      a[#a+1] = argA[i]
   end
   a[#a+1] = Escape.."[0m"
   return concatTbl(a,"")
end

--------------------------------------------------------------------------
-- This prints the array of strings without any colorization.
-- @param color The key name for the *colorT* hash table.
function plain(color, ...)
   local argA = pack(...)
   if (argA.n < 1) then
      return ""
   end
   local a = {}
   for i = 1, argA.n do
      a[#a+1] = argA[i]
   end
   return concatTbl(a,"")
end

function colorize_kind()
   return s_colorize_kind
end


function colorize_init()
   local lmod_colorize = cosmic:value("LMOD_COLORIZE")
   if (lmod_colorize == "force" or (connected2Term() and lmod_colorize == "yes" )) then
      s_colorize_kind = "full"
      _G.colorize     = full_colorize
   else
      s_colorize_kind = "plain"
      _G.colorize     = plain
   end
end

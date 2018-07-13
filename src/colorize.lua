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
require("utils")
require("haveTermSupport")
require("myGlobals")

local Foreground = "\027".."[1;"
local colorT = {
   black      = "30",
   red        = "31",
   green      = "32",
   yellow     = "33",
   blue       = "34",
   magenta    = "35",
   cyan       = "36",
   white      = "37",
}
local cosmic    = require("Cosmic"):singleton()
local concatTbl = table.concat
local s_colorize_kind = "unknown"
local hiddenItalic    = cosmic:value("LMOD_HIDDEN_ITALIC")
------------------------------------------------------------------------
-- Takes an array of strings and wraps the ANSI color start and
-- stop and produces a single string.
-- @param color The key name for the *colorT* hash table.
function full_colorize(color, ... )
   local argA = pack(...)
   if (color == nil or argA.n < 1) then
      return plain(color, ...)
   end

   local a = {}
   if (color == "hidden") then
      a[#a+1] = (hiddenItalic == "yes") and "\027".."[3m" or "\027".."[2m"
      for i = 1, argA.n do
         a[#a+1] = argA[i]
      end
      a[#a+1] = "\027".."[0m"
      return concatTbl(a,"")
   end

   a[#a+1] = Foreground
   a[#a+1] = colorT[color]
   a[#a+1] = 'm'

   for i = 1, argA.n do
      a[#a+1] = argA[i]
   end
   a[#a+1] = "\027" .. "[0m"

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

local lmod_colorize = cosmic:value("LMOD_COLORIZE")
if (lmod_colorize == "force" or (connected2Term() and lmod_colorize == "yes" )) then
   s_colorize_kind = "full"
   _G.colorize     = full_colorize
else
   s_colorize_kind = "plain"
   _G.colorize     = plain
end

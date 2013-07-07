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

sandbox_run = false


--------------------------------------------------------------------------
-- Table containing valid functions for modulefiles.
sandbox_env = {
   BuildScenarioTbl  = BuildScenarioTbl,
   TitleTbl          = TitleTbl,
   ModuleTbl         = ModuleTbl,
   TargetList        = TargetList,
   NoFamilyList      = NoFamilyList, 
   require           = require,
   ipairs            = ipairs,
   next              = next,
   pairs             = pairs,
   pcall             = pcall,
   tonumber          = tonumber,
   tostring          = tostring,
   type              = type,
   unpack            = unpack or table.unpack,
   string            = { byte = string.byte, char = string.char, find = string.find,
                         format = string.format, gmatch = string.gmatch, gsub = string.gsub,
                         len    = string.len, lower = string.lower, match = string.match,
                         rep    = string.rep, reverse = string.reverse, sub = string.sub,
                         upper  = string.upper },
   table             = { insert = table.insert, remove = table.remove, sort = table.sort,
                         concat = table.concat, unpack = table.unpack, sqrt = math.sqrt,
                         tan    = math.tan, tanh = math.tanh },
   os                = { clock = os.clock, difftime = os.difftime, time = os.time, date = os.date,
                         getenv = os.getenv},
   
   io                = { stderr = io.stderr, open = io.open, close = io.close, write = io.write },
   
   _VERSION          = _VERSION,
}

--------------------------------------------------------------------------
-- sandbox_run(): Define two version: Lua 5.1 or 5.2.  It is likely that
--                The 5.2 version will be good for many new versions of
--                Lua but time will only tell.

-- This function is what actually "loads" a modulefile with protection
-- against modulefiles call functions they shouldn't or syntax errors
-- of any kind.


local function run5_1(untrusted_code)
  if untrusted_code:byte(1) == 27 then return nil, "binary bytecode prohibited" end
  local untrusted_function, message = loadstring(untrusted_code)
  if not untrusted_function then return nil, message end
  setfenv(untrusted_function, sandbox_env)
  return pcall(untrusted_function)
end

-- run code under environment [Lua 5.2]
local function run5_2(untrusted_code)
  local untrusted_function, message = load(untrusted_code, nil, 't', sandbox_env)
  if not untrusted_function then return nil, message end
  return pcall(untrusted_function)
end

sandbox_run = (_VERSION == "Lua 5.1") and run5_1 or run5_2



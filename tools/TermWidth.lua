--------------------------------------------------------------------------
-- Use tput cols to find the number of columns.  Then check
-- stderr to see if it is connected to a tty.  If not then
-- use 80 columns wide as default.
--
-- @module TermWidth

require("strict")

-----------------------------------------------------------------------
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


_G._DEBUG          = false                       -- Required by luaposix 33
local posix        = require("posix")
local unistd       = require("posix.unistd")
local wait         = require("posix.sys.wait")
-- Pull the signal API from the posix.signal submodule.  On the merged `posix`
-- table `posix.signal` is the signal() *function* (e.g. luaposix 35 on EL9), so
-- `posix.signal.kill` errors at load time and Lmod fails to start; requiring the
-- submodule gives a table with kill/signal and the SIG* constants on every
-- supported luaposix.
local psignal      = require("posix.signal")
local kill         = psignal.kill
local SIGALRM      = psignal.SIGALRM
local SIGKILL      = psignal.SIGKILL
local setenv_posix = posix.setenv

require("haveTermSupport")
local getenv  = os.getenv
local term    = false
local s_width = false
local min     = math.min
local s_DFLT  = 80

-- Bound stty/tput probes below.  A wedged PTY (ioctl(TIOCGWINSZ) that
-- never returns) would otherwise leave `module` blocked forever inside
-- io.popen :read("*all") -- see GH-832.  Kept local to TermWidth so
-- general capture() callers are unaffected.
local s_termWidthTimeout = 1

local function l_withCaptureEnv(fn)
   local cosmic = require("Cosmic"):singleton()
   local newT   = {}
   local envT   = {}
   local env_ldT = {
      LMOD_LD_LIBRARY_PATH = "LD_LIBRARY_PATH",
      LMOD_LD_PRELOAD      = "LD_PRELOAD",
   }

   for k, v in pairs(env_ldT) do
      local value = cosmic:get(k, "")
      if (value ~= "") then
         envT[v] = value
      end
   end

   for k, v in pairs(envT) do
      newT[k] = getenv(k) or false
      setenv_posix(k, v, true)
   end

   local result = fn()

   for k, myValue in pairs(newT) do
      local v = myValue
      if (v == false) then v = nil end
      setenv_posix(k, v, true)
   end

   return result
end

local function l_timedCapture(cmd, sec)
   return l_withCaptureEnv(function ()
      local r, w = unistd.pipe()
      if (not r) then
         return nil
      end

      local pid = unistd.fork()
      if (pid == 0) then
         unistd.close(r)
         unistd.dup2(w, 1)
         unistd.close(w)
         os.execute("sh -c " .. string.format("%q", cmd))
         os.exit(0)
      end

      unistd.close(w)

      local timed  = false
      local cpid   = pid
      local oldSig = psignal.signal(SIGALRM, function ()
         timed = true
         kill(cpid, SIGKILL)
      end)

      unistd.alarm(sec)

      local outA = {}
      while (true) do
         local chunk = unistd.read(r, 4096)
         if (not chunk or chunk == "") then
            break
         end
         outA[#outA + 1] = chunk
      end

      unistd.alarm(0)
      psignal.signal(SIGALRM, oldSig)
      unistd.close(r)
      wait.wait(cpid)

      if (timed) then
         return nil
      end

      return table.concat(outA)
   end)
end

------------------------------------------------------------------------
-- Ask system for width.

local function l_askSystem(width)

   -- try stty size
   local r_c = l_timedCapture("stty size 2> /dev/null", s_termWidthTimeout)
   if (r_c) then
      local i, j, rows, columns = r_c:find('(%d+)%s+(%d+)')
      if (i) then
         return tonumber(columns)
      end
   end

   -- Try tput cols
   if (getenv("TERM")) then
      local result = l_timedCapture("tput cols 2> /dev/null", s_termWidthTimeout)
      if (result) then
         local i, j, columns = result:find("^(%d+)")
         if (i) then
            return tonumber(columns)
         end
      end
   end

   return width
end


--------------------------------------------------------------------------
-- Returns the number of columns to use as the terminal width.

function TermWidth()
   if (s_width) then
      return s_width
   end
   local ltw = tonumber(getenv("LMOD_TERM_WIDTH"))  -- Note tonumber(nil) is nil not zero
   if (ltw) then
      s_width = ltw
      return s_width
   end

   local cols = tonumber(getenv("COLUMNS"))
   if (cols) then
      s_width = cols
   else
      s_DFLT  = ltw or s_DFLT
      s_width = s_DFLT
      if (haveTermSupport()) then
         s_width = l_askSystem(s_width)
      end
   end

   local maxW = ltw or math.huge

   s_width = min(maxW, s_width)
   s_width = (s_width > 30) and s_width or 30

   return s_width
end

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
--  Copyright (C) 2008-2014 Robert McLay
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
require("declare")

local M        = {}
local posix    = require("posix")

function M.master(self)
   for k, v in pairs(self) do
      if (k:find("^build_")) then
         v()
      end
   end
end

function M.build_epoch_function()
   if (posix.gettimeofday) then
      local gettimeofday = posix.gettimeofday
      local x1, x2 = gettimeofday()
      if (x2 == nil) then
         epoch_type = "posix.gettimeofday() (1)"
         _G.epoch = function()
            local t = gettimeofday()
            return t.sec + t.usec*1.0e-6
         end
      else
         epoch_type = "posix.gettimeofday() (2)"
         _G.epoch = function()
            local t1, t2 = gettimeofday()
            return t1 + t2*1.0e-6
         end
      end
   else
      epoch_type = "os.time"
      local time = os.time
      _G.epoch = function()
         return time()
      end
   end
end

function M.build_allow_dups_function()
   local dups = LMOD_DUPLICATE_PATHS
   if (dups == "yes") then
      _G.allow_dups = function (dupsIn)
         return dupsIn
      end
   else
      _G.allow_dups = function (dupsIn)
         return false
      end
   end
end

--------------------------------------------------------------------------
-- Create the accept functions to allow or ignore TCL modulefiles.
function M.build_accept_functions()
   local allow_tcl = LMOD_ALLOW_TCL_MFILES

   if (allow_tcl == "no") then
      _G.accept_fn = function (fn)
         return fn:find("%.lua$")
      end
   else
      _G.accept_fn = function (fn)
         return true
      end
   end
end


--------------------------------------------------------------------------
-- Return the *prepend_order* function.  This function control which order
-- are prepends handled when there are multiple paths passed to a single
-- call.
function M.build_prepend_order_function()
   local ansT = {
      no      = "reverse",
      reverse = "reverse",
      normal  = "normal",
      yes     = "normal",
   }

   local order = ansT[LMOD_PREPEND_BLOCK] or "normal"
   if (order == "normal") then
      _G.prepend_order = function (n)
         return n, 1, -1
      end
   else
      _G.prepend_order = function (n)
         return 1, n, 1
      end
   end
end

return M

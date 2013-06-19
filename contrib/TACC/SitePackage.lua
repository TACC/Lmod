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
require("serializeTbl")
require("myGlobals")
require("string_split")
require("string_trim")
local Dbg    = require("Dbg")
PkgBase      = require("PkgBase")
local hook   = require("Hook")
local getenv = os.getenv
local posix  = require("posix")

Pkg = PkgBase.build("PkgTACC")
--------------------------------------------------------------------------
-- load_hook(): Here we record the any modules loaded during a batch job.


local function load_hook(t)

   local dbg = Dbg:dbg()
   dbg.start("load_hook()")
   ------------------------------------------------------------------------
   -- Exit out if regular (not a batch job)
   ------------------------------------------------------------------------
   if (getenv("ENVIRONMENT") ~= "BATCH") then
      dbg.fini()
      return
   end

   ------------------------------------------------------------------------
   -- Exit out if MPI rank is greater than zero
   ------------------------------------------------------------------------
   local A = {"PMI_RANK", "PMI_ID", "OMPI_COMM_WORLD_RANK",
              "OMPI_MCA_ns_nds_vpid"}


   for i = 1,#A do
      local my_rank = tonumber(getenv(A[i])) or 0
      if (my_rank > 0) then
         dbg.fini()
         return
      end
   end

   ------------------------------------------------------------------------
   -- If here then we are in a BATCH environment and if we have a rank
   -- it is zero.  So write record.
   ------------------------------------------------------------------------

   dbg.print("fullName: ",t.modFullName,"\n")
   local moduleInfoT = { modFullName=t.modFullName, fn=t.fn}
   local s           = serializeTbl{name="moduleInfoT", value=moduleInfoT}
   local uuid        = UUIDString(os.time())
   local dirN        = usrSBatchDir
   local fn          = pathJoin(dirN, uuid .. ".lua")

   if (not isDir(dirN)) then
      mkdir_recursive(dirN)
   end

   local f = io.open(fn,"w")
   if (f) then
      f:write(s)
      f:close()
   end
   dbg.fini()
end

buildHostsT = {
   ["build.stampede.tacc.utexas.edu"]    = 1,
   ["c560-904.stampede.tacc.utexas.edu"] = 1,
   ["build.ls4.tacc.utexas.edu"]         = 1,
   ["build.longhorn"]                    = 1,
}

--------------------------------------------------------------------------
-- writeCache_hook(): set dontWriteCache on build machines

local function writeCache_hook(t)
   local userName = getenv("USER")
   local host     = posix.uname("%n")

   if (buildHostsT[host]) then
      t.dontWriteCache = true
   end
end

local function parse_updateFn_hook(updateSystemFn, t)
   local attr = lfs.attributes(updateSystemFn)
   if (not attr or type(attr) ~= "table") then
      return
   end

   t.lastUpdateEpoch = attr.modification
   local f           = assert(io.open(updateSystemFn,"r"))
   local whole       = f:read("*all")
   f:close()

   for line in whole:split("\n") do
      line = line:trim()
      if (not line:find("^[#!-]")) then
         local i =  line:find("=")
         if (i) then
            local k = line:sub(1,i-1):trim()
            local v = line:sub(i+1,-1):trim()
            t[k] = v
         end
      end
   end
   t.hostType = t.nodeType or "unknown"
end

hook.register("load",           load_hook)
hook.register("parse_updateFn", parse_updateFn_hook)
hook.register("writeCache",     writeCache_hook)

sandbox_registration { Pkg = Pkg }

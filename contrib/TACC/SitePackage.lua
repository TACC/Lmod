require("strict")
require("serializeTbl")
require("myGlobals")
require("string_split")
require("string_trim")
local hook   = require("Hook")
local getenv = os.getenv
local posix  = require("posix")

local function load_hook(t)
   
   ------------------------------------------------------------------------
   -- Exit out if regular (not a batch job)
   ------------------------------------------------------------------------
   if (getenv("ENVIRONMENT") ~= "BATCH") then
      return
   end

   ------------------------------------------------------------------------
   -- Exit out if MPI rank is greater than zero
   ------------------------------------------------------------------------
   local A = {"PMI_RANK", "PMI_ID", "MPIRUN_RANK",
              "OMPI_COMM_WORLD_RANK", "OMPI_MCA_ns_nds_vpid"}


   for i = 1,#A do
      local my_rank = tonumber(getenv(A[i])) or 0
      if (my_rank > 0) then
         return
      end
   end

   ------------------------------------------------------------------------
   -- If here then we are in a BATCH environment and if we have a rank
   -- it is zero.  So write record.
   ------------------------------------------------------------------------

   local moduleInfoT = { modFullName=t.modFullName, fn=t.fn}
   local s           = serializeTbl{name="moduleInfoT", value=moduleInfoT}
   local uuid        = UUIDString(os.time())
   local dirN        = pathJoin(getenv("HOME"), ".lmod.d", ".saveBatch")
   local fn          = pathJoin(dirN, uuid .. ".lua")

   if (not isDir(dirN)) then
      mkdir_recursive(dirN)
   end

   local f = io.open(fn,"w")
   if (f) then
      f:write(s)
      f:close()
   end
end

buildHostsT = {
   ["build.stampede.tacc.utexas.edu"]    = 1,
   ["c560-904.stampede.tacc.utexas.edu"] = 1,
   ["build.ls4.tacc.utexas.edu"]         = 1,
   ["build.longhorn"]                    = 1,
}
   
local function writeCache_hook(t)
   local userName = getenv("USER")
   local host     = posix.uname("%n")

   if (buildHostsT[host]) then
      t.dontWriteCache = true
   end
end

local function parse_updateFn_hook(updateSystemFn, t)
   local attr = lfs.attributes(updateSystemFn)
   if (not attr or type(attr) == "table") then
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

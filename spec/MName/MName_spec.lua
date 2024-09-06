_G._DEBUG=false
local posix     = require("posix")

require("strict")
require("utils")
require("string_utils")
initialize_lmod()
require("fileOps")

local MName     = require("MName")
local ModuleA   = require("ModuleA")
local FrameStk  = require("FrameStk")

local concatTbl = table.concat
local cosmic    = require("Cosmic"):singleton()
local dbg       = require("Dbg"):dbg()
local testDir   = "spec/MName"
setenv_lmod_version()
describe("Testing MName Class #MName.",
         function()
            it("Test finding modules with NVV files",
               function()
                  local projDir = os.getenv("PROJDIR")
                  local mpathA  = {
                     pathJoin(projDir, testDir, "mf"),
                     pathJoin(projDir, testDir, "mf2"),
                  }
                  local mpath    = concatTbl(mpathA,":")
                  local maxdepth = mpathA[1] .. ":2;" .. mpathA[2] .. ":2;"
                  posix.setenv("MODULEPATH",mpath,true)
                  posix.setenv("LMOD_MAXDEPTH",maxdepth,true)
                  cosmic:assign("LMOD_MAXDEPTH",maxdepth)
                  __removeEnvMT()

                  local debug = os.getenv("LMOD_DEBUG")
                  if (debug == "yes" or debug == "MName" ) then
                     dbg:activateDebug(1)
                  end

                  local moduleA = ModuleA:singleton{reset=true}
                  local goldA = {
                     { value = "bio/g",      sn = "bio/g",  version = false,   action = "match",
                       fn = "%ProjDir%/spec/MName/mf/bio/g.lua"},
                     { value = "TACC",       sn = "TACC",   version = false,   action = "match",
                       fn = "%ProjDir%/spec/MName/mf/TACC.lua"},
                     { value = "T2",         sn = "T2",     version = false,   action = "match",
                       fn = "%ProjDir%/spec/MName/mf2/T2"},
                     { value = "foo",        sn = "foo",   version = "3.0",    action = "match",
                       fn = "%ProjDir%/spec/MName/mf/foo/3.0.lua"},
                     { value = "foo/3.0",    sn = "foo",   version = "3.0",    action = "match",
                       fn = "%ProjDir%/spec/MName/mf/foo/3.0.lua"},
                     { value = "foo/2.1",    sn = "foo",   version = "2.1",    action = "match",
                       fn = "%ProjDir%/spec/MName/mf/foo/2.1.lua"},
                     { value = "foo/1.0",    sn = "foo",   version = "1.0",    action = "match",
                       fn = "%ProjDir%/spec/MName/mf/foo/1.0"},
                     { value = "icr/64/3.9", sn = "icr",   version = "64/3.9", action = "match",
                       fn = "%ProjDir%/spec/MName/mf2/icr/64/3.9"},
                     { value = "icr/32",     sn = "icr",   version = "32/3.6", action = "match",
                       fn = "%ProjDir%/spec/MName/mf/icr/32/3.6"},
                     { value = "icr",        sn = "icr",   version = "64/3.7", action = "match",
                       fn = "%ProjDir%/spec/MName/mf/icr/64/3.7"},
                     { value = "icr/32/3.5", sn = "icr",   version = "32/3.5", action = "latest",
                       fn = "%ProjDir%/spec/MName/mf/icr/32/3.5"},
                     { value = "icr/32",     sn = "icr",   version = "32/3.7", action = "latest",
                       fn = "%ProjDir%/spec/MName/mf/icr/32/3.7"},
                     { value = "icr",        sn = "icr",   version = "64/3.8", action = "latest",
                       fn = "%ProjDir%/spec/MName/mf/icr/64/3.8"},
                     { value = "bio/bt",    sn = "bio/bt", version = "64/3.0", action = "match",
                       fn = "%ProjDir%/spec/MName/mf/bio/bt/64/3.0.lua"},
                     { value = "bio/bt/32", sn = "bio/bt", version = "32/3.0", action = "match",
                       fn = "%ProjDir%/spec/MName/mf/bio/bt/32/3.0.lua"},

                     { value = "mpi/impi/64/5.0.3/049", sn = "mpi/impi", version = "64/5.0.3/049",
                       action = "match", fn = "%ProjDir%/spec/MName/mf2/mpi/impi/64/5.0.3/049"},
                     { value = "mpi/impi/64/5.0.3", sn = "mpi/impi", version = "64/5.0.3/048",
                       action = "match", fn = "%ProjDir%/spec/MName/mf/mpi/impi/64/5.0.3/048"},
                  }

                  local projDirE = projDir:escape()
                  for i = 1, #goldA do
                     local gold     = goldA[i]
                     dbg.print{"RTM MName:new(\"load\", ",gold.value,",", gold.action,")\n"}
                     local mname    = MName:new("load", gold.value, gold.action)
                     dbg.print{"RTM MName:sn()\n"}
                     local sn       = mname:sn()
                     local fn       = (mname:fn() or ""):gsub(projDirE,"%%ProjDir%%")
                     local version  = mname:version()
                     dbg.print{"RTM MName:fullName()\n"}
                     local fullName = mname:fullName()
                     dbg.print{"RTM tests\n"}
                     local g_full   = build_fullName(gold.sn, gold.version)

                     assert.are.equal(gold.sn,      sn)
                     assert.are.equal(gold.fn,      fn)
                     assert.are.equal(gold.version, version)
                     assert.are.equal(g_full,       fullName)

                  end

                  goldA = {
                     { value = "foo",        sn = "foo",   version = "3.0",    action = "atleast",
                       fn = "%ProjDir%/spec/MName/mf/foo/3.0.lua",  is = "2.5"},
                     { value = "icr/32",     sn = "icr",   version = "32/3.6", action = "atleast",
                       fn = "%ProjDir%/spec/MName/mf/icr/32/3.6",  is = "32/3.5.1"},
                     { value = "icr",        sn = "icr",   version = "64/3.8", action = "atleast",
                       fn = "%ProjDir%/spec/MName/mf/icr/64/3.8",  is = "64/3.7.1"},
                     { value = "icr",        sn = "icr",   version = "64/3.8", action = "between",
                       fn = "%ProjDir%/spec/MName/mf/icr/64/3.8",  is = "64/3.7.1", ie = "64/4.0" },
                     { value = "icr",        sn = "icr",   version = "64/3.7", action = "between",
                       fn = "%ProjDir%/spec/MName/mf/icr/64/3.7",  is = "64/3.0", ie = "64/4.0" },
                     { value = "icr",        sn = "icr",   version = "64/3.7", action = "between",
                       fn = "%ProjDir%/spec/MName/mf/icr/64/3.7",  is = "64/3.7", ie = "64/4.0" },
                     { value = "icr",        sn = "icr",   version = "64/3.7", action = "between",
                       fn = "%ProjDir%/spec/MName/mf/icr/64/3.7",  is = "64/3.7", ie = "64/3.7" },
                  }

                  for i = 1, #goldA do
                     local gold     = goldA[i]
                     local mname    = MName:new("load", gold.value, gold.action, gold.is, gold.ie)
                     local sn       = mname:sn()
                     local fn       = (mname:fn() or ""):gsub(projDirE,"%%ProjDir%%")
                     local version  = mname:version()
                     local fullName = mname:fullName()
                     local g_full   = build_fullName(gold.sn, gold.version)

                     assert.are.equal(g_full,       fullName)
                     assert.are.equal(gold.sn,      sn)
                     assert.are.equal(gold.fn,      fn)
                     assert.are.equal(gold.version, version)

                  end
               end)
            it("Test finding modules with NV modulefiles",
               function()
                  local projDir = os.getenv("PROJDIR")
                  local mpathA  = {
                     pathJoin(projDir, testDir, "nv"),
                     pathJoin(projDir, testDir, "nv2"),
                  }
                  local mpath = concatTbl(mpathA,":")

                  posix.setenv("MODULEPATH", mpath, true)
                  cosmic:assign("LMOD_MAXDEPTH",false)
                  ModuleA:__clear()
                  FrameStk:__clear()
                  local goldA = {
                     { value = "foo",        sn = "foo",   version = "2.0",    action = "match",
                       fn = "%ProjDir%/spec/MName/nv/foo/2.0.lua"},
                     { value = "bio/g",      sn = "bio/g",  version = false,   action = "match",
                       fn = "%ProjDir%/spec/MName/nv/bio/g.lua"},
                     { value = "foo",        sn = "foo",   version = "3.0",    action = "latest",
                       fn = "%ProjDir%/spec/MName/nv2/foo/3.0"},
                     { value = "bio/bt",     sn = "bio/bt",version = "3.8",    action = "match",
                       fn = "%ProjDir%/spec/MName/nv2/bio/bt/3.8"},
                     { value = "bio/bt",     sn = "bio/bt",version = "3.9",    action = "latest",
                       fn = "%ProjDir%/spec/MName/nv/bio/bt/3.9"},
                  }

                  local projDirE = projDir:escape()
                  for i = 1, #goldA do
                     local gold     = goldA[i]
                     local mname    = MName:new("load", gold.value, gold.action)
                     local sn       = mname:sn()
                     local fn       = (mname:fn() or ""):gsub(projDirE,"%%ProjDir%%")
                     local version  = mname:version()
                     local fullName = mname:fullName()
                     local g_full   = build_fullName(gold.sn ,gold.version)

                     assert.are.equal(gold.fn,      fn)
                     assert.are.equal(g_full,       fullName)
                     assert.are.equal(gold.sn,      sn)
                     assert.are.equal(gold.version, version)

                  end

                  goldA = {
                     { value = "foo",        sn = "foo",   version = "3.0",    action = "atleast",
                       fn = "%ProjDir%/spec/MName/nv2/foo/3.0",  is = "2.5"},
                  }

                  for i = 1, #goldA do
                     local gold     = goldA[i]
                     local mname    = MName:new("load", gold.value, gold.action, gold.is, gold.ie)
                     local sn       = mname:sn()
                     local fn       = (mname:fn() or ""):gsub(projDirE,"%%ProjDir%%")
                     local version  = mname:version()
                     local fullName = mname:fullName()
                     local g_full   = build_fullName(gold.sn, gold.version)

                     assert.are.equal(g_full,       fullName)
                     assert.are.equal(gold.sn,      sn)
                     assert.are.equal(gold.fn,      fn)
                     assert.are.equal(gold.version, version)

                  end
            end)
         end
)


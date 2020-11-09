_G._DEBUG=false
local posix   = require("posix")

require("strict")

_G.MasterControl = require("MasterControl")
local DirTree    = require("DirTree")
local FrameStk   = require("FrameStk")
local MRC        = require("MRC")
local MT         = require("MT")
local ModuleA    = require("ModuleA")
local cosmic     = require("Cosmic"):singleton()
local dbg        = require("Dbg"):dbg()
local testDir    = "spec/MRC"

describe("Testing MRC class #MRC.",
         function()
            it("Test parsing of modA",
               function()
                  local mrc = MRC:singleton()
                  local ModA={
                     {kind="module_version",module_name="/15.0.2",      module_versionA={"15.0","15"}},
                     {kind="module_version",module_name="intel/14.0.3", module_versionA={"14.0"}},
                     {kind="module_version",module_name="intel/14.0",   module_versionA={"14"}},
                     {kind="module_version",module_name="intel/14",     module_versionA={"default"}},
                  }
                  local defaultV = mrc:parseModA_for_moduleA("intel", "/path/to/nowhere", ModA)
                  assert.are.equal("intel/14.0.3" , defaultV)

                  ModA={
                     {kind="module_version", module_name="/15.0.2", module_versionA={"15.0","15"}},
                     {kind="module_version", module_name="/14.0.5", module_versionA={"14.0"}},
                     {kind="module_version", module_name="/14.0",   module_versionA={"14"}},
                     {kind="module_version", module_name="/14",     module_versionA={"default"}},
                  }
                  defaultV = mrc:parseModA_for_moduleA("acme", "/path/to/nowhere", ModA)
                  assert.are.equal("acme/14.0.5" , defaultV)
               end)
            it("Test of MRC tables",
               function()
                  gold_mrcT = {
                     alias2modT = {},
                     hiddenT = {},
                     version2modT = {
                        ["c/2.0"] = "c/2.0.1",
                     },
                  }

                  gold_mrcMpathT = {
                     ["%ProjDir%/spec/MRC/mf"]  = {
                        version2modT = {
                           ["a/1.0"] = "a/1.0.1",
                           ["b/1.0"] = "b/1.0.14",
                           ["b/2.0"] = "b/2.0.15",
                           ["b/3.0"] = "b/3.14.15",
                        },
                     },
                  }
                  local projDir = os.getenv("PROJDIR")
                  local base    = pathJoin(projDir, testDir)
                  local mpath   = pathJoin(base,    "mf")
                  posix.setenv("MODULEPATH",mpath,true)
                  _G.mcp             = _G.MasterControl.build("load")
                  _G.MCP             = _G.MasterControl.build("load")
                  posix.setenv("HOME",base, true)
                  cosmic:assign("LMOD_MODULERCFILE",pathJoin(projDir,testDir,"dot.modulerc.lua"))
                  --dbg:activateDebug(1)
                  MRC:__clear()
                  local moduleA = ModuleA:singleton{reset=true, spider_cache=true}
                  local mrc     = MRC:singleton()
                  local mrcT, mrcMpathT = mrc:extract()
                  local rplmntA      = { {projDir,"%%ProjDir%%"} }
                  local _mrcMpathT   = {}
                  sanizatizeTbl(rplmntA, mrcMpathT, _mrcMpathT)
                  --print(serializeTbl{indent=true, name="mrcT",      value = mrcT})
                  --print(serializeTbl{indent=true, name="mrcMpathT", value = _mrcMpathT}) 
                  assert.are.same(gold_mrcT,       mrcT)
                  assert.are.same(gold_mrcMpathT, _mrcMpathT)
               end)
         end
)

require("strict")

local dbg          = require("Dbg"):dbg()
local MRC          = require("MRC")
local testDir      = "spec/MRC"

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
                  local defaultV = mrc:parseModA_for_moduleA("intel", ModA)
                  assert.are.equal("intel/14.0.3" , defaultV)

                  ModA={
                     {kind="module_version", module_name="/15.0.2", module_versionA={"15.0","15"}},
                     {kind="module_version", module_name="/14.0.3", module_versionA={"14.0"}},
                     {kind="module_version", module_name="/14.0",   module_versionA={"14"}},
                     {kind="module_version", module_name="/14",     module_versionA={"default"}},
                  }
                  defaultV = mrc:parseModA_for_moduleA("intel", ModA)
                  assert.are.equal("intel/14.0.3" , defaultV)
               end)
         end
)

_G._DEBUG=false
local posix         = require("posix")

require("strict")
require("utils")
initialize_lmod()

require("fileOps")
require("loadModuleFile")
require("modfuncs")

_G.MainControl    = require("MainControl")
local FrameStk      = require("FrameStk")
local Hub        = require("Hub")
local MName         = require("MName")
local ModuleA       = require("ModuleA")
local cosmic        = require("Cosmic"):singleton()
local dbg           = require("Dbg")
local getenv        = os.getenv
local testDir       = "spec/MainControl"

setenv_lmod_version()
describe("Testing MainControl Class #MainControl.",
         function()
            it("Building mcp",
               function()

                  -- for some reason we need to set the global mcp
                  -- via _G.   I need to check to see if this is a
                  -- testing framework issue or just plain Lua.

                  _G.mcp = MainControl.build("load")
                  assert.are.equal("MC_Load",mcp:name())

                  local frameStk = FrameStk:singleton()
                  local entryT = {
                     fn       = "%ProjDir%/spec/MainControl/mf/foo/1.0.lua",
                     sn       = "foo",
                     userName = "foo",
                     version  = "1.0",
                  }

                  frameStk:push(MName:new("entryT",entryT))

                  -- Test setting a variable using the Load version of
                  -- mcp
                  setenv("FOO","BAR")

                  assert.are.equal(entryT.fn, myFileName())

                  frameStk:pop()
                  local varT = frameStk:varT()
                  assert.are.equal("BAR",varT["FOO"]:expand())

                  -- Now set mcp to be unload and test
                  -- that setenv() will unset the variable.
                  _G.mcp = MainControl.build("unload")
                  assert.are.equal("MC_Unload",mcp:name())

                  setenv("FOO","BAR")
                  assert.are.equal(false, varT["FOO"]:expand())
               end)
            it("Loading a simple module",
               function()
                  _G.mcp = MainControl.build("load")
                  _G.MCP = MainControl.build("load")
                  local projDir = os.getenv("PROJDIR")
                  local mpath   = pathJoin(projDir,testDir,"mf")
                  posix.setenv("MODULEPATH", mpath, true)

                  cosmic:assign("LMOD_MAXDEPTH", false)
                  FrameStk:__clear()
                  ModuleA:__clear()
                  local frameStk = FrameStk:singleton()
                  local mpathA   = frameStk:mt():modulePathA()

                  -- Test loading a simple module
                  mcp:load{MName:new("load","bar")}
                  frameStk       = FrameStk:singleton()
                  local varT     = frameStk:varT()
                  assert.are.equal("2.0",varT["BAR_VERSION"]:expand())
                  assert.are.equal("2.0",getenv("BAR_VERSION"))

                  -- Test one name rule
                  mcp:load{MName:new("load","bar/1.0")}
                  varT           = frameStk:varT()
                  assert.are.equal("1.0",varT["BAR_VERSION"]:expand())
                  assert.are.equal("1.0",getenv("BAR_VERSION"))

                  -- Test pushenv
                  posix.setenv("BAZ_COLOR","GREEN",true)
                  local mname = MName:new("load","baz")
                  mcp:load{mname}
                  varT     = frameStk:varT()
                  assert.are.equal("BLUE",varT["BAZ_COLOR"]:expand())
                  assert.are.equal("bash",varT["MY_SHELL"]:expand())
                  unload_internal{mname}
                  assert.are.equal("GREEN",getenv("BAZ_COLOR"))
               end)
         end
)

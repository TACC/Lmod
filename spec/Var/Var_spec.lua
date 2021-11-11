_G._DEBUG=false
local posix        = require("posix")

require("strict")

local Var          = require("Var")
initialize_lmod()
local setenv_posix = posix.setenv
local testDir      = "spec/Var"

describe("Testing Var Class #Var.",
         function()
            it("Test Var Class",
               function()
                  local var = Var:new("FOO")
                  var:set("BAR")
                  local s = var:expand()
                  assert.are.equal("BAR",s)

                  local MY_PATH="/a/b/c:/d/e/f"
                  setenv_posix("MY_PATH",MY_PATH, true)

                  var = Var:new("MY_PATH")
                  assert.are.equal(MY_PATH, var:expand())

                  var:prepend("/first/path:/second/path")
                  assert.are.equal("/first/path:/second/path:" .. MY_PATH, var:expand())

                  var:append("/last/path")

                  assert.are.equal("/first/path:/second/path:" .. MY_PATH .. ":/last/path", var:expand())

                  var:remove("/second/path:/last/path")

                  assert.are.equal("/first/path:" .. MY_PATH , var:expand())
               end)
         end
)

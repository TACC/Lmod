_G._DEBUG=false
require("strict")
require("fileOps")
require("utils")
require("serializeTbl")
local DirTree   = require("DirTree")
local ModuleA   = require("ModuleA")
local LocationT = require("LocationT")
local concatTbl = table.concat
local getenv    = os.getenv
local posix     = require("posix")
local testDir   = "spec/LocationT"

describe("Testing LocationT Class #LocationT.",
         function()
            it("build locationT and compare",
               function()
                  local projDir = os.getenv("PROJDIR")
                  local mpathA  = {
                     pathJoin(projDir, testDir, "nv"),
                     pathJoin(projDir, testDir, "nv2"),
                  }
                  local mpath = concatTbl(mpathA,":")
                  posix.setenv("MODULEPATH", mpath, true)
                  posix.setenv("LMOD_MAXDEPTH", nil, true)
                  local goldT = {
                     ["bio/bt"]  = {
                        dirT = {},
                        fileT = {
                           ["bio/bt/3.7"]  = {
                              ["canonical"] = "3.7",
                              ["fn"] = "%ProjDir%/spec/LocationT/nv/bio/bt/3.7",
                              ["mpath"] = "%ProjDir%/spec/LocationT/nv",
                              ["pV"] = "000000003.000000007.*zfinal",
                              ["wV"] = "000000003.000000007.*zfinal",
                           },
                           ["bio/bt/3.8"]  = {
                              ["canonical"] = "3.8",
                              ["fn"] = "%ProjDir%/spec/LocationT/nv2/bio/bt/3.8",
                              ["mpath"] = "%ProjDir%/spec/LocationT/nv2",
                              ["pV"] = "000000003.000000008.*zfinal",
                              ["wV"] = "^00000003.000000008.*zfinal",
                           },
                           ["bio/bt/3.9"]  = {
                              ["canonical"] = "3.9",
                              ["fn"] = "%ProjDir%/spec/LocationT/nv/bio/bt/3.9",
                              ["mpath"] = "%ProjDir%/spec/LocationT/nv",
                              ["pV"] = "000000003.000000009.*zfinal",
                              ["wV"] = "000000003.000000009.*zfinal",
                           },
                        },
                     },
                     ["bio/g"]  = {
                        dirT = {},
                        ["file"] = "%ProjDir%/spec/LocationT/nv/bio/g.lua",
                        fileT = {},
                        ["mpath"] = "%ProjDir%/spec/LocationT/nv",
                     },
                     foo = {
                        dirT = {},
                        fileT = {
                           ["foo/1.0"]  = {
                              ["canonical"] = "1.0",
                              ["fn"] = "%ProjDir%/spec/LocationT/nv/foo/1.0",
                              ["mpath"] = "%ProjDir%/spec/LocationT/nv",
                              ["pV"] = "000000001.*zfinal",
                              ["wV"] = "000000001.*zfinal",
                           },
                           ["foo/2.0"]  = {
                              ["canonical"] = "2.0",
                              ["fn"] = "%ProjDir%/spec/LocationT/nv/foo/2.0.lua",
                              ["luaExt"] = 4,
                              ["mpath"] = "%ProjDir%/spec/LocationT/nv",
                              ["pV"] = "000000002.*zfinal",
                              ["wV"] = "^00000002.*zfinal",
                           },
                           ["foo/3.0"]  = {
                              ["canonical"] = "3.0",
                              ["fn"] = "%ProjDir%/spec/LocationT/nv2/foo/3.0",
                              ["mpath"] = "%ProjDir%/spec/LocationT/nv2",
                              ["pV"] = "000000003.*zfinal",
                              ["wV"] = "000000003.*zfinal",
                           },
                        },
                     },
                  }
                  
                  mpathA          = path2pathA(getenv("MODULEPATH"))
                  local maxdepthT = paired2pathT(getenv("LMOD_MAXDEPTH"))
                  local moduleA   = ModuleA:__new(mpathA, maxdepthT)
                  local locationT = moduleA:locationT()
                  
                  local rplmntA = { {projDir,"%%ProjDir%%"} }
                  local _locationT = {}
                  sanizatizeTbl(rplmntA, locationT, _locationT)
                  --print(serializeTbl{indent=true, name="locationT",value=_locationT})
                  --print(serializeTbl{indent=true, name="goldT",    value=goldT})
                  assert.same(goldT, _locationT)
               end)
         end
)

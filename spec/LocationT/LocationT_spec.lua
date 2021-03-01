_G._DEBUG=false
local posix     = require("posix")

require("strict")
require("fileOps")
require("utils")
require("serializeTbl")
_G.MasterControl = require("MasterControl")
local DirTree    = require("DirTree")
local ModuleA    = require("ModuleA")
local LocationT  = require("LocationT")
local concatTbl  = table.concat
local cosmic     = require("Cosmic"):singleton()
local getenv     = os.getenv
local testDir    = "spec/LocationT"

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
                        fileT = {
                           ["bio/g"] = {
                              ["Version"] = false,
                              ["canonical"] = "",
                              ["fn"] = "%ProjDir%/spec/LocationT/nv/bio/g.lua",
                              ["luaExt"] = 2,
                              ["mpath"] = "%ProjDir%/spec/LocationT/nv",
                              ["pV"] = "M.*zfinal",
                              ["wV"] = "M.*zfinal",
                           },
                        },
                     },
                     foo = {
                        dirT = {},
                        fileT = {
                           ["foo/.version.1.0"]  = {
                              ["canonical"] = ".version.1.0",
                              ["dot_version"] = 1,
                              ["fn"] = "%ProjDir%/spec/LocationT/nv/foo/.version.1.0",
                              ["mpath"] = "%ProjDir%/spec/LocationT/nv",
                              ["pV"] = "*version.000000001.*zfinal",
                              ["wV"] = "*version.000000001.*zfinal",
                           },
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

                  local clearDS   = true -- clear doubleSlash
                  mpathA          = path2pathA(getenv("MODULEPATH"),':', clearDS)
                  local maxdepthT = paired2pathT(getenv("LMOD_MAXDEPTH"))
                  local moduleA   = ModuleA:__new(mpathA, maxdepthT)
                  local locationT = moduleA:locationT()

                  local rplmntA = { {projDir,"%%ProjDir%%"} }
                  local _locationT = {}
                  sanizatizeTbl(rplmntA, locationT, _locationT)
                  -- print(serializeTbl{indent=true, name="locationT",value=_locationT})
                  -- print(serializeTbl{indent=true, name="goldT",    value=goldT})
                  assert.same(goldT, _locationT)
               end)
            it("Test of meta module and regular modules with same name",
               function()
                  local goldT = {
                     Foo = {
                        dirT = {},
                        fileT = {
                           Foo = {
                              ["Version"] = false,
                              ["canonical"] = "",
                              ["fn"] = "%ProjDir%/spec/LocationT/mf/A/Foo.lua",
                              ["luaExt"] = 4,
                              ["mpath"] = "%ProjDir%/spec/LocationT/mf/A",
                              ["pV"] = "M.*zfinal",
                              ["wV"] = "M.*zfinal",
                           },
                           ["Foo/1.0"]  = {
                              ["Version"] = "1.0",
                              ["canonical"] = "1.0",
                              ["fn"] = "%ProjDir%/spec/LocationT/mf/B/Foo/1.0.lua",
                              ["luaExt"] = 4,
                              ["mpath"] = "%ProjDir%/spec/LocationT/mf/B",
                              ["pV"] = "000000001.*zfinal",
                              ["wV"] = "000000001.*zfinal",
                           },
                           ["Foo/2.0"]  = {
                              ["Version"] = "2.0",
                              ["canonical"] = "2.0",
                              ["fn"] = "%ProjDir%/spec/LocationT/mf/B/Foo/2.0.lua",
                              ["luaExt"] = 4,
                              ["mpath"] = "%ProjDir%/spec/LocationT/mf/B",
                              ["pV"] = "000000002.*zfinal",
                              ["wV"] = "000000002.*zfinal",
                           },
                        },
                     },
                  }
                  local projDir  = os.getenv("PROJDIR")
                  local base     = pathJoin(projDir, testDir,"mf")
                  local mpath    = pathJoin(base, "A") .. ":" .. pathJoin(base, "B")
                  local maxdepth = pathJoin(base, "A") .. ":2;" .. pathJoin(base, "B") .. ":2;"

                  posix.setenv("HOME",base, true)
                  posix.setenv("MODULEPATH",mpath,true)
                  cosmic:assign("LMOD_MAXDEPTH",maxdepth)

                  _G.mcp          = _G.MasterControl.build("load")
                  _G.MCP          = _G.MasterControl.build("load")
                  local moduleA   = ModuleA:singleton{reset=true, spider_cache=true}
                  local locationT = moduleA:locationT()

                  local rplmntA = { {projDir,"%%ProjDir%%"} }
                  local _locationT = {}
                  sanizatizeTbl(rplmntA, locationT, _locationT)
                  --print(serializeTbl{indent=true, name="locationT",value=_locationT})
                  --print(serializeTbl{indent=true, name="goldT",    value=goldT})
                  assert.same(goldT, _locationT)
               end
            )
            it("2nd Test of meta module and regular modules with same name",
               function()
                  local goldT = {
                     Foo = {
                        dirT = {},
                        fileT = {
                           Foo = {
                              ["Version"] = false,
                              ["canonical"] = "",
                              ["fn"] = "%ProjDir%/spec/LocationT/mf/A/Foo.lua",
                              ["luaExt"] = 4,
                              ["mpath"] = "%ProjDir%/spec/LocationT/mf/A",
                              ["pV"] = "M.*zfinal",
                              ["wV"] = "M.*zfinal",
                           },
                           ["Foo/1.0"]  = {
                              ["Version"] = "1.0",
                              ["canonical"] = "1.0",
                              ["fn"] = "%ProjDir%/spec/LocationT/mf/B/Foo/1.0.lua",
                              ["luaExt"] = 4,
                              ["mpath"] = "%ProjDir%/spec/LocationT/mf/B",
                              ["pV"] = "000000001.*zfinal",
                              ["wV"] = "000000001.*zfinal",
                           },
                           ["Foo/2.0"]  = {
                              ["Version"] = "2.0",
                              ["canonical"] = "2.0",
                              ["fn"] = "%ProjDir%/spec/LocationT/mf/B/Foo/2.0.lua",
                              ["luaExt"] = 4,
                              ["mpath"] = "%ProjDir%/spec/LocationT/mf/B",
                              ["pV"] = "000000002.*zfinal",
                              ["wV"] = "000000002.*zfinal",
                           },
                        },
                     },
                  }
                  local projDir  = os.getenv("PROJDIR")
                  local base     = pathJoin(projDir, testDir,"mf")
                  local mpath    = pathJoin(base, "B") .. ":"   .. pathJoin(base, "A")
                  local maxdepth = pathJoin(base, "B") .. ":2;" .. pathJoin(base, "A") .. ":2;"

                  posix.setenv("HOME",base, true)
                  posix.setenv("MODULEPATH",mpath,true)
                  cosmic:assign("LMOD_MAXDEPTH",maxdepth)

                  _G.mcp          = _G.MasterControl.build("load")
                  _G.MCP          = _G.MasterControl.build("load")
                  local moduleA   = ModuleA:singleton{reset=true, spider_cache=true}
                  local locationT = moduleA:locationT()

                  local rplmntA = { {projDir,"%%ProjDir%%"} }
                  local _locationT = {}
                  sanizatizeTbl(rplmntA, locationT, _locationT)
                  --print(serializeTbl{indent=true, name="locationT",value=_locationT})
                  --print(serializeTbl{indent=true, name="goldT",    value=goldT})
                  assert.same(goldT, _locationT)
               end
            )
            it("3rd Test of meta module and regular modules with same name",
               -- Note: This case has a directory named Foo and a module named "Foo.lua"
               -- Lmod choses the directory over the meta module named Foo.
               -- This is because there is no way that a TCL module named "Foo" and
               -- a directory named "Foo" can exist at the same time.
               function()
                  local goldT = {
                     Foo = {
                        dirT = {},
                        fileT = {
                           ["Foo/1.0"]  = {
                              ["Version"] = "1.0",
                              ["canonical"] = "1.0",
                              ["fn"] = "%ProjDir%/spec/LocationT/mf2/Foo/1.0.lua",
                              ["luaExt"] = 4,
                              ["mpath"] = "%ProjDir%/spec/LocationT/mf2",
                              ["pV"] = "000000001.*zfinal",
                              ["wV"] = "000000001.*zfinal",
                           },
                           ["Foo/2.0"]  = {
                              ["Version"] = "2.0",
                              ["canonical"] = "2.0",
                              ["fn"] = "%ProjDir%/spec/LocationT/mf2/Foo/2.0.lua",
                              ["luaExt"] = 4,
                              ["mpath"] = "%ProjDir%/spec/LocationT/mf2",
                              ["pV"] = "000000002.*zfinal",
                              ["wV"] = "000000002.*zfinal",
                           },
                        },
                     },
                  }
                  local projDir  = os.getenv("PROJDIR")
                  local base     = pathJoin(projDir, testDir)
                  local mpath    = pathJoin(base,    "mf2")
                  local maxdepth = mpath .. ":2;"

                  posix.setenv("HOME",base, true)
                  posix.setenv("MODULEPATH",mpath,true)
                  cosmic:assign("LMOD_MAXDEPTH",maxdepth)

                  _G.mcp          = _G.MasterControl.build("load")
                  _G.MCP          = _G.MasterControl.build("load")
                  local moduleA   = ModuleA:singleton{reset=true, spider_cache=true}
                  local locationT = moduleA:locationT()

                  local rplmntA = { {projDir,"%%ProjDir%%"} }
                  local _locationT = {}
                  sanizatizeTbl(rplmntA, locationT, _locationT)
                  --print(serializeTbl{indent=true, name="locationT",value=_locationT})
                  --print(serializeTbl{indent=true, name="goldT",    value=goldT})
                  assert.same(goldT, _locationT)
               end
            )
         end
)

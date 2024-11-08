_G._DEBUG=false
local posix     = require("posix")

require("strict")
require("utils")
initialize_lmod()
require("fileOps")
require("serializeTbl")

_G.MainControl   = require("MainControl")
local DirTree    = require("DirTree")
local MT         = require("MT")
local ModuleA    = require("ModuleA")
local FrameStk   = require("FrameStk")
local dbg        = require("Dbg"):dbg()
local concatTbl  = table.concat
local cosmic     = require("Cosmic"):singleton()
local getenv     = os.getenv
local testDir    = "spec/ModuleA"
setenv_lmod_version()
describe("Testing ModuleA Class #ModuleA.",
         function()
            it("Build moduleA from mf",
               function()
                  local goldA = {
                     {
                        T = {
                           ["bio/bowtie"]  = {
                              defaultA = {
                                 {
                                    ["barefn"] = ".version",
                                    ["defaultIdx"] = 4,
                                    ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/.version",
                                    ["fullName"] = "bio/bowtie/.version",
                                    ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                                    ["value"] = "64",
                                 },
                              },
                              defaultT = {
                                 ["barefn"] = ".version",
                                 ["defaultIdx"] = 4,
                                 ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/.version",
                                 ["fullName"] = "bio/bowtie/.version",
                                 ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                                 ["value"] = "64",
                              },
                              dirT = {
                                 ["bio/bowtie/.128"]  = {
                                    defaultA = {},
                                    defaultT = {},
                                    dirT = {},
                                    fileT = {
                                       ["bio/bowtie/.128/1.0"]  = {
                                          ["Version"] = ".128/1.0",
                                          ["canonical"] = "1.0",
                                          ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/.128/1.0.lua",
                                          ["luaExt"] = 4,
                                          ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                                          ["pV"] = "000000000.000000128/000000001.*zfinal",
                                          ["wV"] = "000000000.000000128/000000001.*zfinal",
                                       },
                                    },
                                 },
                                 ["bio/bowtie/32"]  = {
                                    defaultA = {},
                                    defaultT = {},
                                    dirT = {},
                                    fileT = {
                                       ["bio/bowtie/32/.3.0"]  = {
                                          ["Version"] = "32/.3.0",
                                          ["canonical"] = ".3.0",
                                          ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/32/.3.0.lua",
                                          ["luaExt"] = 5,
                                          ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                                          ["pV"] = "000000032/000000000.000000003.*zfinal",
                                          ["wV"] = "000000032/000000000.000000003.*zfinal",
                                       },
                                       ["bio/bowtie/32/1.0"]  = {
                                          ["Version"] = "32/1.0",
                                          ["canonical"] = "1.0",
                                          ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/32/1.0.lua",
                                          ["luaExt"] = 4,
                                          ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                                          ["pV"] = "000000032/000000001.*zfinal",
                                          ["wV"] = "000000032/000000001.*zfinal",
                                       },
                                       ["bio/bowtie/32/2.0"]  = {
                                          ["Version"] = "32/2.0",
                                          ["canonical"] = "2.0",
                                          ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/32/2.0.lua",
                                          ["luaExt"] = 4,
                                          ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                                          ["pV"] = "000000032/000000002.*zfinal",
                                          ["wV"] = "000000032/000000002.*zfinal",
                                       },
                                    },
                                 },
                                 ["bio/bowtie/64"]  = {
                                    defaultA = {
                                       {
                                          ["barefn"] = ".modulerc",
                                          ["defaultIdx"] = 3,
                                          ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/64/.modulerc",
                                          ["fullName"] = "bio/bowtie/64/.modulerc",
                                          ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                                          ["value"] = "bio/bowtie/64/2.0",
                                       },
                                    },
                                    defaultT = {
                                       ["barefn"] = ".modulerc",
                                       ["defaultIdx"] = 3,
                                       ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/64/.modulerc",
                                       ["fullName"] = "bio/bowtie/64/.modulerc",
                                       ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                                       ["value"] = "bio/bowtie/64/2.0",
                                    },
                                    dirT = {},
                                    fileT = {
                                       ["bio/bowtie/64/2.0"]  = {
                                          ["Version"] = "64/2.0",
                                          ["canonical"] = "2.0",
                                          ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/64/2.0.lua",
                                          ["luaExt"] = 4,
                                          ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                                          ["pV"] = "000000064/000000002.*zfinal",
                                          ["wV"] = "^00000064/^00000002.*zfinal",
                                       },
                                    },
                                 },
                              },
                              fileT = {},
                           },
                           ["bio/genomics"]  = {
                              defaultA = {},
                              defaultT = {},
                              dirT = {},
                              fileT = {
                                 ["bio/genomics"]  = {
                                    ["Version"] = false,
                                    ["canonical"] = "",
                                    ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/genomics.lua",
                                    ["luaExt"] = 9,
                                    ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                                    ["pV"] = "M.*zfinal",
                                    propT = {
                                       arch = {
                                          ["mic"] = 1,
                                       },
                                    },
                                    ["wV"] = "M.*zfinal",
                                 },
                              },
                           },
                           boost = {
                              defaultA = {},
                              defaultT = {},
                              dirT = {},
                              fileT = {
                                 ["boost/1.46.0"]  = {
                                    ["Version"] = "1.46.0",
                                    ["canonical"] = "1.46.0",
                                    ["fn"] = "%ProjDir%/spec/ModuleA/mf/boost/1.46.0.lua",
                                    ["luaExt"] = 7,
                                    ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                                    ["pV"] = "000000001.000000046.*zfinal",
                                    ["wV"] = "000000001.000000046.*zfinal",
                                 },
                              },
                           },
                        },
                        ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                     },
                  }

                  local projDir = os.getenv("PROJDIR")
                  local mpath = pathJoin(projDir, testDir, "mf")
                  posix.setenv("MODULEPATH",mpath,true)
                  local maxdepth = mpath .. ":2;"
                  cosmic:assign("LMOD_MAXDEPTH",maxdepth)
                  _G.mcp             = _G.MainControl.build("load")
                  _G.MCP             = _G.MainControl.build("load")
                  --dbg:activateDebug(1)
                  local moduleA      = ModuleA:singleton{reset=true, spider_cache=true}
                  local mA           = moduleA:moduleA()
                  local rplmntA      = { {projDir,"%%ProjDir%%"} }
                  local _mA          = {}
                  sanizatizeTbl(rplmntA, mA, _mA)
                  --print(serializeTbl{indent=true, name="mA",   value = _mA})
                  --print(serializeTbl{indent=true, name="goldA",value = goldA})
                  local iret = assert.are.same(goldA, _mA)

                  local defaultT = moduleA:defaultT()

                  local gold_defaultT = {
                     ["%ProjDir%/spec/ModuleA/mf/bio/bowtie/64/2.0.lua"]  = {
                        ["count"] = 3,
                        ["fullName"] = "bio/bowtie/64/2.0",
                        ["sn"] = "bio/bowtie",
                        ["weight"] = "^00000064/^00000002.*zfinal",
                     },
                     ["%ProjDir%/spec/ModuleA/mf/bio/genomics.lua"]  = {
                        ["count"] = 1,
                        ["fullName"] = "bio/genomics",
                        ["sn"] = "bio/genomics",
                        ["weight"] = "M.*zfinal",
                     },
                     ["%ProjDir%/spec/ModuleA/mf/boost/1.46.0.lua"]  = {
                        ["count"] = 1,
                        ["fullName"] = "boost/1.46.0",
                        ["sn"] = "boost",
                        ["weight"] = "000000001.000000046.*zfinal",
                     },
                  }

                  local _defaultT = {}
                  sanizatizeTbl(rplmntA, defaultT, _defaultT)
                  --print(serializeTbl{indent=true, name="defaultT",value = _defaultT})
                  assert.are.same(gold_defaultT, _defaultT)

                  local availA = moduleA:build_availA()
                  local gold_availA = {
                     {
                        A = {
                           {
                              fn = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/32/1.0.lua",
                              fullName = "bio/bowtie/32/1.0",
                              moduleKindT = {
                                 hidden_loaded = false,
                                 kind = "normal",
                              },
                              pV = "bio/bowtie/000000032/000000001.*zfinal",
                              sn = "bio/bowtie",
                           },
                           {
                              fn = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/32/2.0.lua",
                              fullName = "bio/bowtie/32/2.0",
                              moduleKindT = {
                                 hidden_loaded = false,
                                 kind = "normal",
                              },
                              pV = "bio/bowtie/000000032/000000002.*zfinal",
                              sn = "bio/bowtie",
                           },
                           {
                              fn = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/64/2.0.lua",
                              fullName = "bio/bowtie/64/2.0",
                              moduleKindT = {
                                 hidden_loaded = false,
                                 kind = "normal",
                              },
                              pV = "bio/bowtie/000000064/000000002.*zfinal",
                              sn = "bio/bowtie",
                           },
                           {
                              fn = "%ProjDir%/spec/ModuleA/mf/bio/genomics.lua",
                              fullName = "bio/genomics",
                              moduleKindT = {
                                 hidden_loaded = false,
                                 kind = "normal",
                              },
                              pV = "bio/genomics/M.*zfinal",
                              propT = {
                                 arch = {
                                    mic = 1,
                                 },
                              },
                              sn = "bio/genomics",
                           },
                           {
                              fn = "%ProjDir%/spec/ModuleA/mf/boost/1.46.0.lua",
                              fullName = "boost/1.46.0",
                              moduleKindT = {
                                 hidden_loaded = false,
                                 kind = "normal",
                              },
                              pV = "boost/000000001.000000046.*zfinal",
                              sn = "boost",
                           },
                        },
                        mpath = "%ProjDir%/spec/ModuleA/mf",
                     },
                  }

                  local _availA = {}
                  sanizatizeTbl(rplmntA, availA, _availA)
                  --dbg:activateDebug(1)
                  dbg.printT("gold_availA",gold_availA)
                  dbg.printT("_availA",    _availA)
                  assert.are.same(gold_availA, _availA)
               end)
            it("Test of meta module and regular modules with the same name",
               function()
                  local goldA = {
                     {
                        T = {
                           Foo = {
                              defaultA = {},
                              defaultT = {},
                              dirT = {},
                              fileT = {
                                 Foo = {
                                    ["Version"] = false,
                                    ["canonical"] = "",
                                    ["fn"] = "%ProjDir%/spec/ModuleA/mf2/Foo.lua",
                                    ["luaExt"] = 4,
                                    ["mpath"] = "%ProjDir%/spec/ModuleA/mf2",
                                    ["pV"] = "M.*zfinal",
                                    ["wV"] = "M.*zfinal",
                                 },
                              },
                           },
                        },
                        ["mpath"] = "%ProjDir%/spec/ModuleA/mf2",
                     },
                     {
                        T = {
                           Foo = {
                              defaultT = {},
                              defaultA = {},
                              dirT = {},
                              fileT = {
                                 ["Foo/1.0"]  = {
                                    ["Version"] = "1.0",
                                    ["canonical"] = "1.0",
                                    ["fn"] = "%ProjDir%/spec/ModuleA/mf3/Foo/1.0.lua",
                                    ["luaExt"] = 4,
                                    ["mpath"] = "%ProjDir%/spec/ModuleA/mf3",
                                    ["pV"] = "000000001.*zfinal",
                                    ["wV"] = "000000001.*zfinal",
                                 },
                                 ["Foo/2.0"]  = {
                                    ["Version"] = "2.0",
                                    ["canonical"] = "2.0",
                                    ["fn"] = "%ProjDir%/spec/ModuleA/mf3/Foo/2.0.lua",
                                    ["luaExt"] = 4,
                                    ["mpath"] = "%ProjDir%/spec/ModuleA/mf3",
                                    ["pV"] = "000000002.*zfinal",
                                    ["wV"] = "000000002.*zfinal",
                                 },
                              },
                           },
                        },
                        ["mpath"] = "%ProjDir%/spec/ModuleA/mf3",
                     },
                  }
                  -- Secret way to wipe out the MT singleton
                  local projDir = os.getenv("PROJDIR")
                  local base  = pathJoin(projDir, testDir)
                  local mpath = pathJoin(base, "mf2") .. ":" .. pathJoin(base, "mf3") 
                  
                  posix.setenv("HOME",base, true)
                  posix.setenv("MODULEPATH",mpath,true)
                  local maxdepth = pathJoin(base, "mf2") .. ":2;" .. pathJoin(base, "mf3") .. ":2;"
                  cosmic:assign("LMOD_MAXDEPTH",maxdepth)
                  _G.mcp             = _G.MainControl.build("load")
                  _G.MCP             = _G.MainControl.build("load")
                  --dbg:activateDebug(1)
                  local moduleA      = ModuleA:singleton{reset=true, spider_cache=true}
                  local mA           = moduleA:moduleA()
                  local rplmntA      = { {projDir,"%%ProjDir%%"} }
                  local _mA          = {}
                  sanizatizeTbl(rplmntA, mA, _mA)
                  --print(serializeTbl{indent=true, name="mA",      value = _mA})
                  --print(serializeTbl{indent=true, name="goldA",   value = goldA})
                  local iret = assert.are.same(goldA, _mA)
               end
            )
         end
)

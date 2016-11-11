_G._DEBUG=false
require("strict")
require("utils")
require("fileOps")
require("serializeTbl")

_G.MasterControl = require("MasterControl")
local DirTree   = require("DirTree")
local ModuleA   = require("ModuleA")

local concatTbl = table.concat
local getenv    = os.getenv
local posix     = require("posix")
local testDir   = "spec/ModuleA"
describe("Testing ModuleA Class #ModuleA.",
         function()
            it("Build moduleA from mf",
               function()
                  local goldA = {
                  {
                     T = {
                        ["bio/bowtie"]  = {
                           defaultT = {
                              ["barefn"] = ".version",
                              ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/.version",
                              ["fullName"] = "bio/bowtie/.version",
                              ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                              ["value"] = "64",
                           },
                           dirT = {
                              ["bio/bowtie/.128"]  = {
                                 defaultT = {},
                                 dirT = {},
                                 fileT = {
                                    ["bio/bowtie/.128/1.0"]  = {
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
                                 defaultT = {},
                                 dirT = {},
                                 fileT = {
                                    ["bio/bowtie/32/.3.0"]  = {
                                       ["canonical"] = ".3.0",
                                       ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/32/.3.0.lua",
                                       ["luaExt"] = 5,
                                       ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                                       ["pV"] = "000000032/000000000.000000003.*zfinal",
                                       ["wV"] = "000000032/000000000.000000003.*zfinal",
                                    },
                                    ["bio/bowtie/32/1.0"]  = {
                                       ["canonical"] = "1.0",
                                       ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/32/1.0.lua",
                                       ["luaExt"] = 4,
                                       ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                                       ["pV"] = "000000032/000000001.*zfinal",
                                       ["wV"] = "000000032/s00000001.*zfinal",
                                    },
                                    ["bio/bowtie/32/2.0"]  = {
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
                                 defaultT = {
                                    ["barefn"] = ".modulerc",
                                    ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/64/.modulerc",
                                    ["fullName"] = "bio/bowtie/64/.modulerc",
                                    ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                                    ["value"] = "bio/bowtie/64/2.0",
                                 },
                                 dirT = {},
                                 fileT = {
                                    ["bio/bowtie/64/2.0"]  = {
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
                           defaultT = {},
                           dirT = {},
                           ["file"] = "%ProjDir%/spec/ModuleA/mf/bio/genomics.lua",
                           fileT = {},
                           metaModuleT = {
                              ["canonical"] = "genomics",
                              ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/genomics.lua",
                              ["luaExt"] = 9,
                              ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                              ["pV"] = "~",
                              ["wV"] = "~",
                              propT = { arch = { ["mic"] = 1} }
                           },
                           ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                        },
                        boost = {
                           defaultT = {},
                           dirT = {},
                           fileT = {
                              ["boost/1.46.0"]  = {
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
                  posix.setenv("LMOD_MAXDEPTH", maxdepth, true)
                  posix.setenv("MODULERCFILE",pathJoin(projDir,testDir,".modulerc"))
                  _G.mcp             = _G.MasterControl.build("load")
                  _G.MCP             = _G.MasterControl.build("load")
                  local moduleA      = ModuleA:singleton{reset=true, spider_cache=true}
                  local mA           = moduleA:moduleA()
                  local rplmntA      = { {projDir,"%%ProjDir%%"} }
                  local _mA          = {}
                  sanizatizeTbl(rplmntA, mA, _mA)
                  --print(serializeTbl{indent=true, name="mA",   value = _mA})
                  --print(serializeTbl{indent=true, name="goldA",value = goldA})
                  assert.are.same(goldA, _mA)

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
                        ["weight"] = " ",
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
                              ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/32/1.0.lua",
                              ["fullName"] = "bio/bowtie/32/1.0",
                              ["pV"] = "bio/bowtie/000000032/000000001.*zfinal",
                              ["sn"] = "bio/bowtie",
                           },
                           {
                              ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/32/2.0.lua",
                              ["fullName"] = "bio/bowtie/32/2.0",
                              ["pV"] = "bio/bowtie/000000032/000000002.*zfinal",
                              ["sn"] = "bio/bowtie",
                           },
                           {
                              ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/bowtie/64/2.0.lua",
                              ["fullName"] = "bio/bowtie/64/2.0",
                              ["pV"] = "bio/bowtie/000000064/000000002.*zfinal",
                              ["sn"] = "bio/bowtie",
                           },
                           {
                              ["fn"] = "%ProjDir%/spec/ModuleA/mf/bio/genomics.lua",
                              ["fullName"] = "bio/genomics",
                              ["pV"] = "bio/genomics",
                              ["sn"] = "bio/genomics",
                              propT = { arch = { ["mic"] = 1} }
                           },
                           {
                              ["fn"] = "%ProjDir%/spec/ModuleA/mf/boost/1.46.0.lua",
                              ["fullName"] = "boost/1.46.0",
                              ["pV"] = "boost/000000001.000000046.*zfinal",
                              ["sn"] = "boost",
                           },
                        },
                        ["mpath"] = "%ProjDir%/spec/ModuleA/mf",
                     },
                  }

                  local _availA = {}
                  sanizatizeTbl(rplmntA, availA, _availA)
                  --print(serializeTbl{indent=true, name="availA",value = _availA})
                  assert.are.same(gold_availA, _availA)
               end)
         end
)

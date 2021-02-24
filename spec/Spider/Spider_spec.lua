_G._DEBUG=false
local posix      = require("posix")

require("strict")
require("utils")
require("fileOps")
require("serializeTbl")
require("StandardPackage")

_G.MasterControl = require("MasterControl")
local ModuleA    = require("ModuleA")
local Spider     = require("Spider")
local concatTbl  = table.concat
local cosmic     = require("Cosmic"):singleton()
local dbg        = require("Dbg"):dbg()
local getenv     = os.getenv
local testDir    = "spec/Spider"
describe("Testing Spider Class #Spider.",
         function()
            it("Core directory Test",
               function()
                  local projDir = getenv("PROJDIR")
                  local mpath = pathJoin(projDir, testDir, "mf/Core")
                  posix.setenv("MODULEPATH",mpath,true)
                  posix.setenv("LMOD_MAXDEPTH", nil, true)
                  cosmic:assign("LMOD_MAXDEPTH",false)

                  local spider  = Spider:new()
                  local spiderT = {}
                  _G.mcp = MasterControl.build("spider")
                  _G.MCP = MasterControl.build("spider")
                  spider:findAllModules({mpath}, spiderT)
                  local gold_spiderT = {
                     ["%ProjDir%/spec/Spider/mf/Core"]  = {
                        TACC = {
                           defaultA = {},
                           defaultT = {},
                           dirT = {},
                           fileT = {
                              TACC = {
                                 ["Version"] = false,
                                 ["canonical"] = "",
                                 ["fn"] = "%ProjDir%/spec/Spider/mf/Core/TACC.lua",
                                 ["luaExt"] = 5,
                                 ["mpath"] = "%ProjDir%/spec/Spider/mf/Core",
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
                        icr = {
                           defaultA = {
                              {
                                 ["barefn"] = ".version",
                                 ["defaultIdx"] = 4,
                                 ["fn"] = "%ProjDir%/spec/Spider/mf/Core/icr/.version",
                                 ["fullName"] = "icr/.version",
                                 ["mpath"] = "%ProjDir%/spec/Spider/mf/Core",
                                 ["value"] = false,
                              },
                           },
                           defaultT = {
                              ["barefn"] = ".version",
                              ["fn"] = "%ProjDir%/spec/Spider/mf/Core/icr/.version",
                              ["defaultIdx"] = 4,
                              ["fullName"] = "icr/.version",
                              ["mpath"] = "%ProjDir%/spec/Spider/mf/Core",
                              ["value"] = false,
                           },
                           dirT = {
                              ["icr/64"]  = {
                                 defaultA = {},
                                 defaultT = {},
                                 dirT = {},
                                 fileT = {
                                    ["icr/64/3.7"]  = {
                                       ["Version"] = "64/3.7",
                                       ["canonical"] = "3.7",
                                       ["fn"] = "%ProjDir%/spec/Spider/mf/Core/icr/64/3.7",
                                       ["mpath"] = "%ProjDir%/spec/Spider/mf/Core",
                                       ["pV"] = "000000064/000000003.000000007.*zfinal",
                                       ["wV"] = "000000064/000000003.000000007.*zfinal",
                                    },
                                 },
                              },
                           },
                           fileT = {},
                        },
                        intel = {
                           defaultA = {},
                           defaultT = {},
                           dirT = {},
                           fileT = {
                              ["intel/.version.19.1"]  = {
                                 ["Version"] = ".version.19.1",
                                 ["canonical"] = ".version.19.1",
                                 ["dot_version"] = 1,
                                 ["fn"] = "%ProjDir%/spec/Spider/mf/Core/intel/.version.19.1",
                                 ["mpath"] = "%ProjDir%/spec/Spider/mf/Core",
                                 ["pV"] = "*version.000000019.000000001.*zfinal",
                                 ["wV"] = "*version.000000019.000000001.*zfinal",
                              },
                              ["intel/19.1"]  = {
                                 ["Category"] = "library, mathematics",
                                 ["Description"] = "the intel compiler collection",
                                 ["Name"] = "intel",
                                 ["URL"] = "http://www.intel.com",
                                 ["Version"] = "19.1",
                                 ["canonical"] = "19.1",
                                 dirA = {
                                    ["/app/intel/19.1"] = 1,
                                 },

                                 ["fn"] = "%ProjDir%/spec/Spider/mf/Core/intel/19.1.lua",
                                 ["help"] = " This is the compiler help message ",
                                 lpathA = {
                                    ["/app/intel/19.1/lib"] = 1,
                                 },
                                 ["luaExt"] = 5,
                                 ["mpath"] = "%ProjDir%/spec/Spider/mf/Core",
                                 ["pV"] = "000000019.000000001.*zfinal",
                                 propT = {
                                    arch = {
                                       ["mic"] = 1,
                                    },
                                 },
                                 ["wV"] = "000000019.000000001.*zfinal",
                                 whatis = {
                                    "Name: intel", "Version: 19.1", "Category: library, mathematics",
                                    "URL: http://www.intel.com", "Description: the intel compiler collection",
                                 },
                              },
                           },
                        },
                     },
                     version = 5,
                  }
                  local rplmntA  = { {projDir,"%%ProjDir%%"} }
                  local _spiderT = {}
                  sanizatizeTbl(rplmntA, spiderT, _spiderT)
                  -- print(serializeTbl{indent=true, name="spiderT",     value = _spiderT})
                  -- print(serializeTbl{indent=true, name="gold_spiderT",value = gold_spiderT})
                  assert.are.same(gold_spiderT, _spiderT)
              end)

            it("Hierarchy directory Test",
               function()
                  --local debug = os.getenv("LMOD_DEBUG")
                  --if (debug == "yes" or debug == "Spider" ) then
                  --   dbg:activateDebug(1)
                  --end

                  local masterTbl  = masterTbl()
                  local projDir    = getenv("PROJDIR")
                  local root_mpath = pathJoin(projDir, testDir, "h/mf")
                  local mpath      = pathJoin(root_mpath,       "Core")

                  posix.setenv("MODULEPATH_ROOT", root_mpath, true)
                  posix.setenv("MODULEPATH",      mpath,      true)
                  posix.setenv("LMOD_MAXDEPTH",   nil,        true)
                  cosmic:assign("LMOD_MAXDEPTH",  false)

                  local spider = Spider:new()
                  local spiderT = {}
                  _G.mcp = MasterControl.build("spider")
                  _G.MCP = MasterControl.build("spider")
                  spider:findAllModules({mpath}, spiderT)
                  local gold_spiderT = {
                     ["%ProjDir%/spec/Spider/h/mf/Compiler/gcc/5.9"]  = {
                        mpich = {
                           defaultT = {},
                           defaultA = {},
                           dirT = {},
                           fileT = {
                              ["mpich/17.200.3"]  = {
                                 ["Version"] = "17.200.3",
                                 ["canonical"] = "17.200.3",
                                 ["fn"] = "%ProjDir%/spec/Spider/h/mf/Compiler/gcc/5.9/mpich/17.200.3.lua",
                                 ["luaExt"] = 9,
                                 ["mpath"] = "%ProjDir%/spec/Spider/h/mf/Compiler/gcc/5.9",
                                 ["pV"] = "000000017.000000200.000000003.*zfinal",
                                 ["wV"] = "000000017.000000200.000000003.*zfinal",
                              },
                           },
                        },
                        python = {
                           defaultA = {},
                           defaultT = {},
                           dirT = {},
                           fileT = {
                              ["python/2.7.9"]  = {
                                 ["Version"] = "2.7.9",
                                 ["canonical"] = "2.7.9",
                                 ["fn"] = "%ProjDir%/spec/Spider/h/mf/Compiler/gcc/5.9/python/2.7.9.lua",
                                 ["luaExt"] = 6,
                                 ["mpath"] = "%ProjDir%/spec/Spider/h/mf/Compiler/gcc/5.9",
                                 ["pV"] = "000000002.000000007.000000009.*zfinal",
                                 ["wV"] = "000000002.000000007.000000009.*zfinal",
                              },
                           },
                        },
                     },
                     ["%ProjDir%/spec/Spider/h/mf/Core"]  = {
                        gcc = {
                           defaultA = {},
                           defaultT = {},
                           dirT = {},
                           fileT = {
                              ["gcc/.version.5.9.2"]  = {
                                 ["Version"] = ".version.5.9.2",
                                 ["canonical"] = ".version.5.9.2",
                                 ["dot_version"] = 1,
                                 ["fn"] = "%ProjDir%/spec/Spider/h/mf/Core/gcc/.version.5.9.2",
                                 ["mpath"] = "%ProjDir%/spec/Spider/h/mf/Core",
                                 ["pV"] = "*version.000000005.000000009.000000002.*zfinal",
                                 ["wV"] = "*version.000000005.000000009.000000002.*zfinal",
                              },
                              ["gcc/5.9.2"]  = {
                                 ["Version"] = "5.9.2",
                                 ["canonical"] = "5.9.2",
                                 ["fn"] = "%ProjDir%/spec/Spider/h/mf/Core/gcc/5.9.2.lua",
                                 ["luaExt"] = 6,
                                 ["mpath"] = "%ProjDir%/spec/Spider/h/mf/Core",
                                 ["pV"] = "000000005.000000009.000000002.*zfinal",
                                 ["wV"] = "000000005.000000009.000000002.*zfinal",
                              },
                           },
                        },
                        python = {
                           defaultA = {},
                           defaultT = {},
                           dirT = {},
                           fileT = {
                              ["python/2.7.9"]  = {
                                 ["Version"] = "2.7.9",
                                 ["canonical"] = "2.7.9",
                                 ["fn"] = "%ProjDir%/spec/Spider/h/mf/Core/python/2.7.9.lua",
                                 ["luaExt"] = 6,
                                 ["mpath"] = "%ProjDir%/spec/Spider/h/mf/Core",
                                 ["pV"] = "000000002.000000007.000000009.*zfinal",
                                 ["wV"] = "000000002.000000007.000000009.*zfinal",
                              },
                           },
                        },
                     },
                     ["%ProjDir%/spec/Spider/h/mf/MPI/gcc/5.9/mpich/17.200"]  = {
                        parmetis = {
                           defaultA = {},
                           defaultT = {},
                           dirT = {},
                           fileT = {
                              ["parmetis/4.0.3"]  = {
                                 ["Version"] = "4.0.3",
                                 ["canonical"] = "4.0.3",
                                 ["fn"] = "%ProjDir%/spec/Spider/h/mf/MPI/gcc/5.9/mpich/17.200/parmetis/4.0.3.lua",
                                 ["luaExt"] = 6,
                                 ["mpath"] = "%ProjDir%/spec/Spider/h/mf/MPI/gcc/5.9/mpich/17.200",
                                 ["pV"] = "000000004.000000000.000000003.*zfinal",
                                 ["wV"] = "000000004.000000000.000000003.*zfinal",
                              },
                           },
                        },
                        python = {
                           defaultA = {},
                           defaultT = {},
                           dirT = {},
                           fileT = {
                              ["python/2.7.9"]  = {
                                 ["Version"] =  "2.7.9",
                                 ["canonical"] = "2.7.9",
                                 ["fn"] = "%ProjDir%/spec/Spider/h/mf/MPI/gcc/5.9/mpich/17.200/python/2.7.9.lua",
                                 ["luaExt"] = 6,
                                 ["mpath"] = "%ProjDir%/spec/Spider/h/mf/MPI/gcc/5.9/mpich/17.200",
                                 ["pV"] = "000000002.000000007.000000009.*zfinal",
                                 ["wV"] = "000000002.000000007.000000009.*zfinal",
                              },
                           },
                        },
                     },
                     ["version"] = 5,
                  }
                  local rplmntA  = { {projDir,"%%ProjDir%%"} }
                  local _spiderT = {}
                  sanizatizeTbl(rplmntA, spiderT, _spiderT)
                  --print(serializeTbl{indent=true, name="spiderT",     value = _spiderT})
                  --print(serializeTbl{indent=true, name="gold_spiderT",value = gold_spiderT})
                  assert.are.same(gold_spiderT, _spiderT)

                  local gold_mpathMapT = {
                      ["%ProjDir%/spec/Spider/h/mf/Compiler/gcc/5.9"]  = {
                         ["gcc/5.9.2"] = "%ProjDir%/spec/Spider/h/mf/Core",
                      },
                      ["%ProjDir%/spec/Spider/h/mf/MPI/gcc/5.9/mpich/17.200"]  = {
                         ["mpich/17.200.3"] = "%ProjDir%/spec/Spider/h/mf/Compiler/gcc/5.9",
                      },
                  }

                  local mpathMapT = {}
                  sanizatizeTbl(rplmntA, masterTbl.mpathMapT, mpathMapT)
                  --print(serializeTbl{indent=true, name="mpathMapT",value = mpathMapT})
                  assert.are.same(gold_mpathMapT, mpathMapT)

                  local dbT = {}
                  --dbg:activateDebug(1)
                  spider:buildDbT({mpath}, masterTbl.mpathMapT, spiderT, dbT)
                  local _dbT = {}
                  sanizatizeTbl(rplmntA, dbT, _dbT)
                  local gold_dbT = {
                     gcc = {
                        ["%ProjDir%/spec/Spider/h/mf/Core/gcc/5.9.2.lua"]  = {
                           ["Version"] = "5.9.2",
                           ["fullName"] = "gcc/5.9.2",
                           ["hidden"] = false,
                           ["pV"] = "000000005.000000009.000000002.*zfinal",
                           ["wV"] = "000000005.000000009.000000002.*zfinal",
                        },
                     },
                     mpich = {
                        ["%ProjDir%/spec/Spider/h/mf/Compiler/gcc/5.9/mpich/17.200.3.lua"]  = {
                           ["Version"] = "17.200.3",
                           ["fullName"] = "mpich/17.200.3",
                           ["hidden"] = false,
                           ["pV"] = "000000017.000000200.000000003.*zfinal",
                           parentAA = {
                              {
                                 "gcc/5.9.2",
                              },
                           },
                           ["wV"] = "000000017.000000200.000000003.*zfinal",
                        },
                     },
                     parmetis = {
                        ["%ProjDir%/spec/Spider/h/mf/MPI/gcc/5.9/mpich/17.200/parmetis/4.0.3.lua"]  = {
                           ["Version"] = "4.0.3",
                           ["fullName"] = "parmetis/4.0.3",
                           ["hidden"] = false,
                           ["pV"] = "000000004.000000000.000000003.*zfinal",
                           parentAA = {
                              {
                                 "gcc/5.9.2", "mpich/17.200.3",
                              },
                           },
                           ["wV"] = "000000004.000000000.000000003.*zfinal",
                        },
                     },
                     python = {
                        ["%ProjDir%/spec/Spider/h/mf/Compiler/gcc/5.9/python/2.7.9.lua"]  = {
                           ["Version"] = "2.7.9",
                           ["fullName"] = "python/2.7.9",
                           ["hidden"] = false,
                           ["pV"] = "000000002.000000007.000000009.*zfinal",
                           parentAA = {
                              {
                                 "gcc/5.9.2",
                              },
                           },
                           ["wV"] = "000000002.000000007.000000009.*zfinal",
                        },
                        ["%ProjDir%/spec/Spider/h/mf/Core/python/2.7.9.lua"]  = {
                           ["Version"] = "2.7.9",
                           ["fullName"] = "python/2.7.9",
                           ["hidden"] = false,
                           ["pV"] = "000000002.000000007.000000009.*zfinal",
                           ["wV"] = "000000002.000000007.000000009.*zfinal",
                        },
                        ["%ProjDir%/spec/Spider/h/mf/MPI/gcc/5.9/mpich/17.200/python/2.7.9.lua"]  = {
                           ["Version"] = "2.7.9",
                           ["fullName"] = "python/2.7.9",
                           ["hidden"] = false,
                           ["pV"] = "000000002.000000007.000000009.*zfinal",
                           parentAA = {
                              {
                                 "gcc/5.9.2", "mpich/17.200.3",
                              },
                           },
                           ["wV"] = "000000002.000000007.000000009.*zfinal",
                        },
                     },
                  }
                  --print(serializeTbl{indent=true, name="dbT",      value = dbT})
                  --print(serializeTbl{indent=true, name="gold_dbT", value = gold_dbT})
                  assert.are.same(gold_dbT, _dbT)
               end)
         end
)

_G._DEBUG=false
require("strict")
require("fileOps")
require("utils")
require("serializeTbl")
local DirTree = require("DirTree")
local dbg     = require("Dbg"):dbg()
local testDir = "spec/DirTree"

describe("Testing DirTree Class: #DirTree.",
         function()
            it("build dirA from mf/bio directory",
               function()
                  local goldA = {
                     {
                        dirT = {
                           defaultT = {},
                           dirT = {
                              bio = {
                                 defaultT = {},
                                 dirT = {
                                    ["bio/bowtie"]  = {
                                       defaultT = {
                                          ["barefn"] = "default",
                                          ["fn"] = "%ProjDir%/spec/DirTree/mf/bio/bowtie/default",
                                          ["fullName"] = "bio/bowtie/default",
                                          ["mpath"] = "%ProjDir%/spec/DirTree/mf",
                                          ["value"] = "64",
                                       },
                                       dirT = {
                                          ["bio/bowtie/32"]  = {
                                             defaultT = {},
                                             dirT = {},
                                             fileT = {
                                                ["bio/bowtie/32/1.0"]  = {
                                                   ["canonical"] = "1.0",
                                                   ["fn"] = "%ProjDir%/spec/DirTree/mf/bio/bowtie/32/1.0.lua",
                                                   ["luaExt"] = 4,
                                                   ["mpath"] = "%ProjDir%/spec/DirTree/mf",
                                                },
                                                ["bio/bowtie/32/2.0"]  = {
                                                   ["canonical"] = "2.0",
                                                   ["fn"] = "%ProjDir%/spec/DirTree/mf/bio/bowtie/32/2.0.lua",
                                                   ["luaExt"] = 4,
                                                   ["mpath"] = "%ProjDir%/spec/DirTree/mf",
                                                },
                                             },
                                          },
                                          ["bio/bowtie/64"]  = {
                                             defaultT = {
                                                ["barefn"] = ".modulerc",
                                                ["fn"] = "%ProjDir%/spec/DirTree/mf/bio/bowtie/64/.modulerc",
                                                ["fullName"] = "bio/bowtie/64/.modulerc",
                                                ["mpath"] = "%ProjDir%/spec/DirTree/mf",
                                                ["value"] = "bio/bowtie/64/2.0",
                                             },
                                             dirT = {},
                                             fileT = {
                                                ["bio/bowtie/64/2.0"]  = {
                                                   ["canonical"] = "2.0",
                                                   ["fn"] = "%ProjDir%/spec/DirTree/mf/bio/bowtie/64/2.0.lua",
                                                   ["luaExt"] = 4,
                                                   ["mpath"] = "%ProjDir%/spec/DirTree/mf",
                                                },
                                             },
                                          },
                                       },
                                       fileT = {},
                                    },
                                 },
                                 fileT = {
                                    ["bio/genomics"]  = {
                                       ["canonical"] = "genomics",
                                       ["fn"] = "%ProjDir%/spec/DirTree/mf/bio/genomics.lua",
                                       ["luaExt"] = 9,
                                       ["mpath"] = "%ProjDir%/spec/DirTree/mf",
                                    },
                                 },
                              },
                              boost = {
                                 defaultT = {},
                                 dirT = {},
                                 fileT = {
                                    ["boost/1.46.0"]  = {
                                       ["canonical"] = "1.46.0",
                                       ["fn"] = "%ProjDir%/spec/DirTree/mf/boost/1.46.0.lua",
                                       ["luaExt"] = 7,
                                       ["mpath"] = "%ProjDir%/spec/DirTree/mf",
                                    },
                                 },
                              },
                              default_file_only = {
                                 defaultT = {
                                    ["barefn"] = "default",
                                    ["fn"] = "%ProjDir%/spec/DirTree/mf/default_file_only/default",
                                    ["fullName"] = "default_file_only/default",
                                    ["mpath"] = "%ProjDir%/spec/DirTree/mf",
                                    ["value"] = "default",
                                 },
                                 dirT = {},
                                 fileT = {
                                    ["default_file_only/default"]  = {
                                       ["canonical"] = "default",
                                       ["fn"] = "%ProjDir%/spec/DirTree/mf/default_file_only/default",
                                       ["mpath"] = "%ProjDir%/spec/DirTree/mf",
                                    },
                                 },
                              },
                           },
                           fileT = {},
                        },
                        ["mpath"] = "%ProjDir%/spec/DirTree/mf",
                     },
                  }
                  local projDir = os.getenv("PROJDIR")
                  local mpathA  = { pathJoin(projDir, testDir, "mf") }
                  --dbg:activateDebug(1)
                  local dirTree = DirTree:new(mpathA)
                  local dirA    = dirTree:dirA()
                  local rplmntA = { {projDir,"%%ProjDir%%"} }
                  local _dirA   = {}
                  sanizatizeTbl(rplmntA, dirA, _dirA)
                  dbg.printT("goldA", goldA)
                  dbg.printT("dirA",  _dirA)
                  assert.are.same(goldA, _dirA)
               end
            )
            it("Testing modulefiles with leading underscores",
               function()
                  local debug = os.getenv("LMOD_DEBUG")
                  if (debug == "yes" or debug == "DirTree" ) then
                     dbg:activateDebug(1)
                  end
                  local projDir = os.getenv("PROJDIR")
                  local mpathA  = { pathJoin(projDir, testDir, "mf_underscore") }
                  local dirTree = DirTree:new(mpathA)
                  local dirA    = dirTree:dirA()
                  local rplmntA = { {projDir,"%%ProjDir%%"} }
                  local _dirA   = {}
                  local goldA   = {
                     {
                        dirT = {
                           defaultT = {},
                           dirT = {
                              ["_A" ] = {
                                 defaultT = {},
                                 dirT = {},
                                 fileT = {
                                    ["_A/1.0"]  = {
                                       ["canonical"] = "1.0",
                                       ["fn"] = "%ProjDir%/spec/DirTree/mf_underscore/_A/1.0.lua",
                                       ["luaExt"] = 4,
                                       ["mpath"] = "%ProjDir%/spec/DirTree/mf_underscore",
                                    },
                                 },
                              },
                              B = {
                                 defaultT = {},
                                 dirT = {},
                                 fileT = {
                                    ["B/2.0"]  = {
                                       ["canonical"] = "2.0",
                                       ["fn"] = "%ProjDir%/spec/DirTree/mf_underscore/B/2.0.lua",
                                       ["luaExt"] = 4,
                                       ["mpath"] = "%ProjDir%/spec/DirTree/mf_underscore",
                                    },
                                 },
                              },
                           },
                           fileT = {},
                        },
                        ["mpath"] = "%ProjDir%/spec/DirTree/mf_underscore",
                     },
                  }
                  sanizatizeTbl(rplmntA, dirA, _dirA)
                  --dbg.printT("goldA", goldA)
                  --dbg.printT("dirA",  _dirA)
                  assert.are.same(goldA, _dirA)
                  
               end
            )
         end
)

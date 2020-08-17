_G._DEBUG=false
local posix   = require("posix")

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
                  local projDir = os.getenv("PROJDIR")
                  local cmd     = "rm -f " .. projDir .. "/spec/DirTree/mf/best/2.0.lua"
                  os.execute(cmd)
                  cmd           = "ln -s 1.0.lua " .. projDir .. "/spec/DirTree/mf/best/2.0.lua"
                  os.execute(cmd)
                  local goldA   = {
                     {
                        dirT = {
                           defaultA = {},
                           defaultT = {},
                           dirT = {
                              bio = {
                                 defaultA = {},
                                 defaultT = {},
                                 dirT = {
                                    ["bio/bowtie"]  = {
                                       defaultA = {
                                          {
                                             ["barefn"] = "default",
                                             ["defaultIdx"] = 1,
                                             ["fn"] = "%ProjDir%/spec/DirTree/mf/bio/bowtie/default",
                                             ["fullName"] = "bio/bowtie/default",
                                             ["mpath"] = "%ProjDir%/spec/DirTree/mf",
                                             ["value"] = "64",
                                          },
                                          {
                                             ["barefn"] = ".version",
                                             ["defaultIdx"] = 4,
                                             ["fn"] = "%ProjDir%/spec/DirTree/mf/bio/bowtie/.version",
                                             ["fullName"] = "bio/bowtie/.version",
                                             ["mpath"] = "%ProjDir%/spec/DirTree/mf",
                                             ["value"] = "64",
                                          },
                                       },
                                       defaultT = {
                                          ["barefn"] = "default",
                                          ["defaultIdx"] = 1,
                                          ["fn"] = "%ProjDir%/spec/DirTree/mf/bio/bowtie/default",
                                          ["fullName"] = "bio/bowtie/default",
                                          ["mpath"] = "%ProjDir%/spec/DirTree/mf",
                                          ["value"] = "64",
                                       },
                                       dirT = {
                                          ["bio/bowtie/32"]  = {
                                             defaultA = {},
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
                                             defaultA = {
                                                {
                                                   ["barefn"] = ".modulerc",
                                                   ["defaultIdx"] = 3,
                                                   ["fn"] = "%ProjDir%/spec/DirTree/mf/bio/bowtie/64/.modulerc",
                                                   ["fullName"] = "bio/bowtie/64/.modulerc",
                                                   ["mpath"] = "%ProjDir%/spec/DirTree/mf",
                                                   ["value"] = "bio/bowtie/64/2.0",
                                                },
                                             },
                                             defaultT = {
                                                ["barefn"] = ".modulerc",
                                                ["defaultIdx"] = 3,
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
                                 defaultA = {},
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
                                 defaultA = {
                                    {
                                       ["barefn"] = "default",
                                       ["defaultIdx"] = 1,
                                       ["fn"] = "%ProjDir%/spec/DirTree/mf/default_file_only/default",
                                       ["fullName"] = "default_file_only/default",
                                       ["mpath"] = "%ProjDir%/spec/DirTree/mf",
                                       ["value"] = "default",
                                    },
                                 },
                                 defaultT = {
                                    ["barefn"] = "default",
                                    ["defaultIdx"] = 1,
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
                           defaultA = {},
                           defaultT = {},
                           dirT = {
                              ["_A" ] = {
                                 defaultA = {},
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
                                 defaultA = {},
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
            it("Test of meta module and regular modules with the same name",
               function()
                  local debug = os.getenv("LMOD_DEBUG")
                  local projDir = os.getenv("PROJDIR")
                  local mpathA  = { pathJoin(projDir, testDir, "mf2"), pathJoin(projDir, testDir, "mf3") }
                  local dirTree = DirTree:new(mpathA)
                  local dirA    = dirTree:dirA()
                  local rplmntA = { {projDir,"%%ProjDir%%"} }
                  local _dirA   = {}
                  local goldA   = {
                       {
                          dirT = {
                             defaultA = {},
                             defaultT = {},
                             dirT = {},
                             fileT = {
                                Foo = {
                                   ["canonical"] = "Foo",
                                   ["fn"] = "%ProjDir%/spec/DirTree/mf2/Foo.lua",
                                   ["luaExt"] = 4,
                                   ["mpath"] = "%ProjDir%/spec/DirTree/mf2",
                                },
                             },
                          },
                          ["mpath"] = "%ProjDir%/spec/DirTree/mf2",
                       },
                       {
                          dirT = {
                             defaultA = {},
                             defaultT = {},
                             dirT = {
                                Foo = {
                                   defaultA = {},
                                   defaultT = {},
                                   dirT = {},
                                   fileT = {
                                      ["Foo/1.0"]  = {
                                         ["canonical"] = "1.0",
                                         ["fn"] = "%ProjDir%/spec/DirTree/mf3/Foo/1.0.lua",
                                         ["luaExt"] = 4,
                                         ["mpath"] = "%ProjDir%/spec/DirTree/mf3",
                                      },
                                      ["Foo/2.0"]  = {
                                         ["canonical"] = "2.0",
                                         ["fn"] = "%ProjDir%/spec/DirTree/mf3/Foo/2.0.lua",
                                         ["luaExt"] = 4,
                                         ["mpath"] = "%ProjDir%/spec/DirTree/mf3",
                                      },
                                   },
                                },
                             },
                             fileT = {},
                          },
                          ["mpath"] = "%ProjDir%/spec/DirTree/mf3",
                       },
                  }
                  sanizatizeTbl(rplmntA, dirA, _dirA)
                  --dbg:activateDebug(1)
                  dbg.printT("goldA", goldA)
                  dbg.printT("dirA",  _dirA)
                  assert.are.same(goldA, _dirA)
               end
            )
            it("Test empty .version file",
               function()
                  local debug = os.getenv("LMOD_DEBUG")
                  local projDir = os.getenv("PROJDIR")
                  local mpathA  = { pathJoin(projDir, testDir, "mf_icr") }
                  local dirTree = DirTree:new(mpathA)
                  local dirA    = dirTree:dirA()
                  local rplmntA = { {projDir,"%%ProjDir%%"} }
                  local _dirA   = {}
                  local goldA   = {
                     {
                        dirT = {
                           defaultT = {},
                           defaultA = {},
                           dirT = {
                              icr = {
                                 defaultA = {
                                    {
                                       ["barefn"] = ".version",
                                       ["defaultIdx"] = 4,
                                       ["fn"] = "%ProjDir%/spec/DirTree/mf_icr/icr/.version",
                                       ["fullName"] = "icr/.version",
                                       ["mpath"] = "%ProjDir%/spec/DirTree/mf_icr",
                                       ["value"] = false,
                                    },
                                 },
                                 defaultT = {
                                    ["barefn"] = ".version",
                                    ["defaultIdx"] = 4,
                                    ["fn"] = "%ProjDir%/spec/DirTree/mf_icr/icr/.version",
                                    ["fullName"] = "icr/.version",
                                    ["mpath"] = "%ProjDir%/spec/DirTree/mf_icr",
                                    ["value"] = false,
                                 },
                                 dirT = {
                                    ["icr/32"]  = {
                                       defaultA = {},
                                       defaultT = {},
                                       dirT = {},
                                       fileT = {
                                          ["icr/32/3.7"]  = {
                                             ["canonical"] = "3.7",
                                             ["fn"] = "%ProjDir%/spec/DirTree/mf_icr/icr/32/3.7",
                                             ["mpath"] = "%ProjDir%/spec/DirTree/mf_icr",
                                          },
                                          ["icr/32/3.8"]  = {
                                             ["canonical"] = "3.8",
                                             ["fn"] = "%ProjDir%/spec/DirTree/mf_icr/icr/32/3.8",
                                             ["mpath"] = "%ProjDir%/spec/DirTree/mf_icr",
                                          },
                                       },
                                    },
                                    ["icr/64"]  = {
                                       defaultA = {},
                                       defaultT = {},
                                       dirT = {},
                                       fileT = {
                                          ["icr/64/3.8"]  = {
                                             ["canonical"] = "3.8",
                                             ["fn"] = "%ProjDir%/spec/DirTree/mf_icr/icr/64/3.8",
                                             ["mpath"] = "%ProjDir%/spec/DirTree/mf_icr",
                                          },
                                          ["icr/64/3.9"]  = {
                                             ["canonical"] = "3.9",
                                             ["fn"] = "%ProjDir%/spec/DirTree/mf_icr/icr/64/3.9",
                                             ["mpath"] = "%ProjDir%/spec/DirTree/mf_icr",
                                          },
                                       },
                                    },
                                 },
                                 fileT = {},
                              },
                           },
                           fileT = {},
                        },
                        ["mpath"] = "%ProjDir%/spec/DirTree/mf_icr",
                     },
                  }
                  sanizatizeTbl(rplmntA, dirA, _dirA)
                  --dbg:activateDebug(1)
                  --dbg.printT("goldA", goldA)
                  --dbg.printT("dirA",  _dirA)
                  assert.are.same(goldA, _dirA)

               end
            )
         end
)

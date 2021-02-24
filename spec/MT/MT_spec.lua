_G._DEBUG=false
local posix     = require("posix")

require("strict")
require("fileOps")
require("deepcopy")
local MName     = require("MName")
local MT        = require("MT")
local cosmic    = require("Cosmic"):singleton()
local dbg       = require("Dbg"):dbg()
local testDir   = "spec/MT"

describe("Testing MT Class #MT.",
         function()
            it("Test fake loading a module",
               function()
                  local mpath = pathJoin("%ProgDir%", testDir, "mf")
                  posix.setenv("MODULEPATH", mpath, true)
                  posix.setenv("LMOD_MAXDEPTH", nil, true)
                  cosmic:assign("LMOD_MAXDEPTH", false)
                  --dbg:activateDebug(1)
                  local mt = MT:singleton{testing=true}
                  local entryA = {
                     {
                        sn       = "icr",
                        fn       = pathJoin("%ProjDir%", testDir, "mf/icr/64/3.8.lua"),
                        version  = "64/3.8",
                        userName = "icr/64",
                        propT    = {arch = "mic"}
                     },
                     {
                        sn       = "TACC",
                        fn       = pathJoin("%ProjDir%", testDir, "mf/TACC.lua"),
                        userName = "TACC",
                        version  = false,
                     },
                  }

                  for i = 1,#entryA do
                     local entryT = entryA[i]
                     local sn     = entryT.sn
                     local mname  = MName:new("entryT",entryT)
                     mt:add(mname, "pending")
                     mt:setStatus(sn, "active")
                     if (entryT.propT) then
                        for name,value in pairs(entryT.propT) do
                           mt:add_property(sn, name, value)
                        end
                     end
                  end

                  local goldT = {
                     ["c_rebuildTime"] = false,
                     ["c_shortTime"] = false,
                     family = {},
                     mT = {
                        icr = {
                           ["fn"] = "%ProjDir%/spec/MT/mf/icr/64/3.8.lua",
                           ["fullName"] = "icr/64/3.8",
                           ["loadOrder"] = 1,
                           propT = { arch = { mic = 1},},
                           ["stackDepth"] = 0,
                           ["status"] = "active",
                           ["userName"] = "icr/64",
                           ["wV"] = false,
                        },
                        TACC = {
                           ["fn"] = "%ProjDir%/spec/MT/mf/TACC.lua",
                           ["fullName"] = "TACC",
                           ["loadOrder"] = 2,
                           propT = {},
                           ["stackDepth"] = 0,
                           ["status"] = "active",
                           ["userName"] = "TACC",
                           ["wV"] = false,
                        },
                     },
                     mpathA = {
                        "%ProgDir%/spec/MT/mf",
                     },
                     systemBaseMPATH = "%ProgDir%/spec/MT/mf",
                     depthT = {},
                     ["MTversion"] = 3,
                  }
                  local projDir = os.getenv("PROJDIR")
                  local rplmntA = { {projDir,"%%ProjDir%%"} }



                  local _mt     = deepcopy(mt)
                  local __mt    = {}
                  sanizatizeTbl(rplmntA, _mt, __mt)
                  assert.are.same(goldT, __mt)

                  local goldA = {
                     {input = "icr",        expected = "64/3.8"},
                     {input = "icr/64",     expected = "64/3.8"},
                     {input = "icr/64/3.8", expected = "64/3.8"},
                     {input = "TACC",       expected = false   },
                  }

                  for i = 1,#goldA do
                     local gold    = goldA[i]
                     local mname   = MName:new("mt", gold.input)
                     local version = mname:version()
                     assert.are.equal(gold.expected, version)
                  end

                  goldA         = { "icr", "TACC" }
                  local activeA = mt:list("sn","active")
                  assert.are.same(goldA, activeA)

                  goldA         = { "icr","icr/64", "icr/64/3.8", "TACC" }
                  activeA       = mt:list("both","active")
                  assert.are.same(goldA, activeA)

                  goldA         = { "icr/64", "TACC" }
                  activeA       = mt:list("userName","active")
                  local resultA = {activeA[1].name, activeA[2].name}
                  assert.are.same(goldA, resultA)

                  goldA         = { "icr/64/3.8", "TACC" }
                  activeA       = mt:list("fullName","active")
                  resultA       = {activeA[1].name, activeA[2].name}
                  assert.are.same(goldA, resultA)


                  ------------------------------------------------------------
                  -- Test if the ModuleTable can be pushed to the environment
                  -- and recovered!
                  local envMT = mt:encodeMT()
                  for k,v in pairs(envMT) do
                     posix.setenv(k,v,true)
                  end

                  -- Secret way to wipe out the MT singleton
                  mt:__clearMT{testing = true}

                  -- Do not set MT from the environment
                  mt         = MT:singleton()
                  _mt        = deepcopy(mt)
                  __mt       = {}
                  _mt        = sanizatizeTbl(rplmntA, _mt, __mt)
                  dbg.printT("mt",__mt)
                  dbg.printT("goldT",goldT)
                  assert.are.same(goldT,__mt)

                  -- Remove MT that was pushed to the environment
                  __removeEnvMT()
               end
            )
         end
)



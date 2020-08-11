_G._DEBUG=false
local posix      = require("posix")

require("strict")
require("utils")
require("fileOps")

_G.MasterControl = require("MasterControl")
local dbg        = require("Dbg"):dbg()
local ModuleA    = require("ModuleA")
local Master     = require("Master")
local cosmic     = require("Cosmic"):singleton()

local concatTbl  = table.concat
local getenv     = os.getenv
local testDir    = "spec/Avail"
describe("Testing The Avail command #Avail.",
         function()
            it("Avail in terse and regular mode",
               function()
                  local projDir    = os.getenv("PROJDIR")
                  local mpath      = pathJoin(projDir, testDir, "mf")
                  posix.setenv("LMOD_TERM_WIDTH","160")
                  posix.setenv("MODULERCFILE",pathJoin(projDir,testDir,".modulerc"))
                  posix.setenv("MODULEPATH",mpath,true)
                  ModuleA:__clear()
                  cosmic:init{name = "LMOD_MAXDEPTH", default=false, assign = mpath .. ":2;"}

                  local master     = Master:singleton()
                  local rplmntA    = { {projDir,"%%ProjDir%%"} }
                  local masterTbl  = masterTbl()
                  _G.mcp           = _G.MasterControl.build("load")
                  _G.MCP           = _G.MasterControl.build("load")

                  masterTbl.terse  = true
                  masterTbl.rt     = true

                  -------------------------------------------------------
                  -- Test 1 avail output in terse mode

                  local a          = master:avail(pack())
                  local _a         = {}
                  sanizatizeTbl(rplmntA, a, _a)
                  --print(serializeTbl{indent=true, name="a",   value = _a})
                  local gold_terseA = {
                     "%ProjDir%/spec/Avail/mf:\n",
                     "bio/bowtie/\n",
                     "bio/bowtie/32/1.0\n",
                     "bio/bowtie/32/2.0\n",
                     "bio/bowtie/64/2.0\n",
                     "bio/genomics\n",
                  }
                  assert.are.same(gold_terseA, _a)

                  -------------------------------------------------------
                  -- Test 2 avail output in terse mode for defaultOnly
                  masterTbl.defaultOnly = true
                  a  = master:avail(pack())
                  _a = {}
                  sanizatizeTbl(rplmntA, a, _a)
                  local gold_terse_defaultA = {
                     "%ProjDir%/spec/Avail/mf:\n",
                     "bio/bowtie/64/2.0\n",
                     "bio/genomics\n",
                  }
                  assert.are.same(gold_terse_defaultA, _a)

                  -------------------------------------------------------
                  -- Test 3 avail output in terse mode with a search string

                  masterTbl.defaultOnly = nil
                  a    = master:avail(pack("genomics"))
                  _a = {}
                  sanizatizeTbl(rplmntA, a, _a)
                  local gold_terse_searchA = {
                     "%ProjDir%/spec/Avail/mf:\n",
                     "bio/genomics\n",
                  }
                  assert.are.same(gold_terse_searchA, _a)

                  -------------------------------------------------------
                  -- Test 4 avail output in terse mode with a search
                  -- string with no match

                  a    = master:avail(pack("gem"))
                  assert.are.same({},a)

                  -------------------------------------------------------
                  -- Test 5 avail output in regular mode

                  masterTbl.terse       = nil
                  a  = master:avail(pack()) or {}
                  _a = {}
                  sanizatizeTbl(rplmntA, a, _a)
                  for i = 1,#_a do
                     _a[i] = _a[i]:gsub("%-%-%-*","---")
                  end

                  local gold_availA = {
                     "\n",
                     "--- %ProjDir%/spec/Avail/mf ---",
                     "\n",
                     "   bio/bowtie/32/1.0    bio/bowtie/64/2.0 (D)\n" ..
                     "   bio/bowtie/32/2.0    bio/genomics",
                     "\n",
                     "\n",
                  }
                  --print("availA:\n", concatTbl(_a,""))
                  --print("gold_availA:\n", concatTbl(gold_availA,""))
                  assert.are.same(gold_availA, _a)
               end)
         end
)

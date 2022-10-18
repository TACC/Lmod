_G._DEBUG=false
local posix      = require("posix")

require("strict")
require("utils")
initialize_lmod()
require("fileOps")

_G.MainControl = require("MainControl")
local dbg        = require("Dbg"):dbg()
local ModuleA    = require("ModuleA")
local Hub     = require("Hub")
local cosmic     = require("Cosmic"):singleton()

local concatTbl  = table.concat
local getenv     = os.getenv
local testDir    = "spec/Avail"
setenv_lmod_version()
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

                  local hub        = Hub:singleton()
                  local rplmntA    = { {projDir,"%%ProjDir%%"} }
                  local optionTbl  = optionTbl()
                  _G.mcp           = _G.MainControl.build("load")
                  _G.MCP           = _G.MainControl.build("load")

                  optionTbl.terse  = true
                  optionTbl.rt     = true

                  -------------------------------------------------------
                  -- Test 1 avail output in terse mode

                  local a          = hub:avail(pack())
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
                  optionTbl.defaultOnly = true
                  a  = hub:avail(pack())
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

                  optionTbl.defaultOnly = nil
                  a    = hub:avail(pack("genomics"))
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

                  a    = hub:avail(pack("gem"))
                  assert.are.same({},a)

                  -------------------------------------------------------
                  -- Test 5 avail output in regular mode

                  posix.setenv("LMOD_QUIET","yes")
                  optionTbl.terse       = nil
                  a  = hub:avail(pack()) or {}
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
                     "\n  Where:\n",
                     "   D:  Default Module",
                     "\n",
                  }
                  assert.are.same(gold_availA, _a)
               end)
         end
)

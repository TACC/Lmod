-- $Id$ --

require("fileOps")
ProjectData = nil

local posix         = require("posix")
local ProjectDBFile = "Hermes.db"

local function FindProjectDataFile()
   local cwd = posix.getcwd()
   local wd  = cwd

   while (wd ~= "/" and not posix.access(ProjectDBFile,"r")) do
      posix.chdir("..")
      wd = posix.getcwd()
   end

   posix.chdir(cwd)
   if (wd == "/") then
      return nil
   else
      return pathJoin(wd,ProjectDBFile)
   end
end

function FindProjectData()
   local results = nil

   local dbfn = FindProjectDataFile()
   if (dbfn) then
      assert(loadfile(dbfn))()
      if (ProjectData) then
         results = ProjectData.TargetList or results
      end
   end
   return results

end

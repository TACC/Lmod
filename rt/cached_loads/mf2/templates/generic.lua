-- -*- lua -*-
-- category: tools
local name = myModuleName()
local version = myModuleVersion()
local hierA = hierarchyA(myModuleFullName(),1)
prepend_path("PATH", pathJoin("/apps",name,version,hierA[1], "bin"))

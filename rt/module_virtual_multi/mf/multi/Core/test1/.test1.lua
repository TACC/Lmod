-- -*- lua -*-
local name    = myModuleName()
local version = myModuleVersion()
whatis("Name: " .. name)
whatis("Version: " .. version)
setenv("TEST1_MV", version)

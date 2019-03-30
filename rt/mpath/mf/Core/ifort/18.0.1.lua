local name        = myModuleName()
local fullVersion = myModuleVersion()
local pkgVersion  = fullVersion:match('(%d+%.%d+)%.?')
local pkgNameVer  = pathJoin("intel",pkgVersion)
local mroot       = os.getenv("MODULEPATH_ROOT")
local base        = pathJoin("/unknown/apps",name,fullVersion)

prepend_path("PATH",            pathJoin(base,"bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base,"lib"))
prepend_path("MODULEPATH",      pathJoin(mroot, "Compiler", pkgNameVer))



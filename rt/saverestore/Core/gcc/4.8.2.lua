local name        = myModuleName()
local fullVersion = myModuleVersion()
local pkgVersion  = fullVersion:match('(%d+%.%d+)%.?')
local pkgNameVer  = pathJoin(name,pkgVersion)
local mroot       = "/unknown/apps/modulefiles"
local base        = pathJoin("/unknown/apps",name,fullVersion)

prepend_path("PATH",            pathJoin(base,"bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base,"lib"))
prepend_path("MODULEPATH",      pathJoin(mroot, "Compiler", pkgNameVer))

family("compiler")


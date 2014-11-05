local name        = myModuleName()
local fullVersion = myModuleVersion()
local pkgVersion  = fullVersion:match('(%d+%.%d+)%.?')
local pkgNameVer  = pathJoin(name,pkgVersion)
local mroot       = os.getenv("MODULEPATH_ROOT")
local appsDir     = os.getenv("APPS_DIR")
local base        = pathJoin(appsDir,name,fullVersion)


prepend_path("PATH",            pathJoin(base,"bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base,"lib"))
prepend_path("MODULEPATH",      pathJoin(mroot, "Compiler", pkgNameVer))

family("compiler")


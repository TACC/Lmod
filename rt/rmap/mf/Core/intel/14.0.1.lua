local name        = myModuleName()
local fullVersion = myModuleVersion()
local pkgVersion  = fullVersion:match('(%d+%.%d+)%.?')
local pkgNameVer  = pathJoin(name,pkgVersion)
local mroot       = os.getenv("MODULEPATH_ROOT")
local base        = pathJoin("/opt/apps",name,fullVersion)

prepend_path("MODULEPATH",      pathJoin(mroot, "Compiler", pkgNameVer))
prepend_path("PATH",            pathJoin(base,"bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base,"lib"))
             
family("compiler")


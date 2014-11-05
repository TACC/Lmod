local name        = myModuleName()
local fullVersion = myModuleVersion()
local pkgVersion  = fullVersion:match('(%d+%.%d+)%.?')
local pkgNameVer  = pathJoin(name,pkgVersion)
local mroot       = os.getenv("MODULEPATH_ROOT")

prepend_path("MODULEPATH", pathJoin(mroot, "Compiler", pkgNameVer))

family("compiler")



-- Core intel module that unlocks Compiler level modules
local name        = myModuleName()
local version     = myModuleVersion()
local pkgVersion  = version:match('(%d+%.%d+)') or version
local mroot       = os.getenv("MODULEPATH_ROOT")

prepend_path("MODULEPATH", pathJoin(mroot, "Compiler", name, pkgVersion))

family("compiler")

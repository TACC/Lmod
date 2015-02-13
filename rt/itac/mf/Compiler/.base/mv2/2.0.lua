local name         = myModuleName()
local fullVersion  = myModuleVersion()
local pkgName      = pathJoin(name, fullVersion)
local hierA        = hierarchyA(pkgName,1)
local compiler_dir = hierA[1]
local pkgVersion   = fullVersion:match('(%d+%.%d+)%.?')

local mroot        = os.getenv("MODULEPATH_ROOT")

prepend_path("MODULEPATH", pathJoin(mroot, "MPI", compiler_dir, name, pkgVersion))

family("MPI")

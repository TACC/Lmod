inherit()
local pkgName     = myModuleName()
local MP_ROOT     = os.getenv("MY_MODULEPATH_ROOT")
local fullVersion = myModuleVersion()
local pkgV        = fullVersion:match('(%d+%.%d+)%.?')
local hierA       = hierarchyA(pathJoin(pkgName,fullVersion),1)
local compilerV   = hierA[1]
local mpath       = pathJoin(MP_ROOT, "MPI", compilerV, pkgName, pkgV)

prepend_path("MODULEPATH", mpath)

             

help([[Sets up the OpenMPI MPI environment.
Depends on: gcc/7.1.0, common
Dependents: Libraries built with this MPI
Family: mpi
]])

local pkgName      = myModuleName()
local fullVersion  = myModuleVersion()
local pkgV         = fullVersion:match('(%d+%.%d+)%.?')
local hierA        = hierarchyA(pathJoin(pkgName,fullVersion),1)
local compilerV    = hierA[1]
local compilerD    = compilerV:gsub("/","-"):gsub("%.","_")
local base         = pathJoin("/opt/apps",compilerD,pkgName,fullVersion)
local mroot        = os.getenv("MODULEPATH_ROOT")
local mpath        = pathJoin(mroot, "MPI", compilerV, pkgName, pkgV)

append_path('MODULEPATH',       mpath)
prepend_path('PATH', pathJoin(base,"bin"))
family("mpi")

load("mpi-common/.openmpi")

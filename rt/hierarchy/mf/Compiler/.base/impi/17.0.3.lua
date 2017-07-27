-- -*- lua -*-

local helpMsg = [[
Intel MPI help
]]

local pkgName      = myModuleName()
local fullVersion  = myModuleVersion()
local pkgV         = fullVersion:match('(%d+%.%d+)%.?')
local hierA        = hierarchyA(pathJoin(pkgName,fullVersion),1)
local compilerV    = hierA[1]
local compilerD    = compilerV:gsub("/","-"):gsub("%.","_")
local base         = pathJoin("/opt/apps",compilerD,pkgName,fullVersion)
local mroot        = os.getenv("MODULEPATH_ROOT")
local mpath        = pathJoin(mroot, "MPI", compilerV, pkgName, pkgV)

whatis("Name: "..pkgName)
whatis("Version "..fullVersion)
whatis("Category: mpi")
whatis("Description: Intel Version of the Message Passing Interface Library")
whatis("Keyword: library, mpi")

help(helpMsg, "Version ",fullVersion)

setenv(      "TACC_IMPI_DIR", base)
setenv(      "TACC_IMPI_LIB", pathJoin(base,"lib"))
setenv(      "TACC_IMPI_BIN", pathJoin(base,"bin"))
setenv(      "TACC_IMPI_INC", pathJoin(base,"include"))
prepend_path("MANPATH",          pathJoin(base,"man"))
prepend_path('MODULEPATH',       mpath)

prepend_path('LD_LIBRARY_PATH', pathJoin(mpihome,"lib"))
prepend_path('LD_LIBRARY_PATH', pathJoin(mpihome,"lib","openmpi"))
setenv(      'MPIHOME',         base)
setenv(      'MPICH_HOME',      base)
family("MPI")

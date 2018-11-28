local pkgName      = myModuleName()
local pkgVersion   = myModuleVersion()
local pkgNameVer   = myModuleFullName()

local hierA        = hierarchyA(pkgNameVer,2)
local mpi_dir      = hierA[1]:gsub("/","-"):gsub("%.","_")
local compiler_dir = hierA[2]:gsub("/","-"):gsub("%.","_")
local pkgRoot      = "/opt/apps"
local base         = pathJoin(pkgRoot, compiler_dir, mpi_dir, pkgNameVer)

setenv(      "TACC_HDF5_DIR",   base)
setenv(      "TACC_HDF5_DOC",   pathJoin(base,"doc"))
setenv(      "TACC_HDF5_INC",   pathJoin(base,"include"))
setenv(      "TACC_HDF5_LIB",   pathJoin(base,"lib"))
setenv(      "TACC_HDF5_BIN",   pathJoin(base,"bin"))
prepend_path("PATH",            pathJoin(base,"bin"))
prepend_path("LD_LIBRARY_PATH", pathJoin(base,"lib"))

family("HDF5")
whatis("Name: Parallel HDF5")
whatis("Version: " .. pkgVersion)
whatis("Category: library, mathematics")
whatis("URL: http://www.hdfgroup.org/HDF5")
whatis("Description: General purpose library and file format for storing scientific data (parallel I/O version)")

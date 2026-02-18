help([==[

Description
===========
The Open MPI Project is an open source MPI-3 implementation.


More information
================
 - Homepage: https://www.open-mpi.org/
]==])

whatis([==[Description: The Open MPI Project is an open source MPI-3 implementation.]==])
whatis([==[Homepage: https://www.open-mpi.org/]==])
whatis([==[URL: https://www.open-mpi.org/]==])

local root = "/hpc2n/eb/software/OpenMPI/4.1.5-GCC-12.3.0"

conflict("OpenMPI")

-- depends_on("hwloc/2.9.1")

-- depends_on("libevent/2.1.12")

-- depends_on("UCX/1.14.1")

-- depends_on("PMIx/4.2.4")

-- depends_on("UCC/1.2.0")
local mroot = os.getenv("MODULEPATH_ROOT") or ""
prepend_path("MODULEPATH", pathJoin(mroot, "MPI", "GCC", "12.3.0", "OpenMPI", "4.1.5"))
if isDir(pathJoin(os.getenv("HOME") or "HOME_NOT_DEFINED", pathJoin("easybuild/modules", "all", "MPI/GCC/12.3.0/OpenMPI/4.1.5"))) then
    prepend_path("MODULEPATH", pathJoin(os.getenv("HOME") or "HOME_NOT_DEFINED", pathJoin("easybuild/modules", "all", "MPI/GCC/12.3.0/OpenMPI/4.1.5")))
end
if isDir(pathJoin(os.getenv("PROJECT") or "PROJECT_NOT_DEFINED", pathJoin("easybuild/modules", "all", "MPI/GCC/12.3.0/OpenMPI/4.1.5"))) then
    prepend_path("MODULEPATH", pathJoin(os.getenv("PROJECT") or "PROJECT_NOT_DEFINED", pathJoin("easybuild/modules", "all", "MPI/GCC/12.3.0/OpenMPI/4.1.5")))
end

prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("MANPATH", pathJoin(root, "share/man"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PKG_CONFIG_PATH", pathJoin(root, "lib/pkgconfig"))
prepend_path("XDG_DATA_DIRS", pathJoin(root, "share"))
setenv("EBROOTOPENMPI", root)
setenv("EBVERSIONOPENMPI", "4.1.5")
setenv("EBDEVELOPENMPI", pathJoin(root, "easybuild/Compiler-GCC-12.3.0-OpenMPI-4.1.5-easybuild-devel"))

setenv("SLURM_MPI_TYPE", "pmix_v3")
setenv("SLURM_PMIX_DIRECT_CONN_UCX", "false")
-- Built with EasyBuild version 4.8.1

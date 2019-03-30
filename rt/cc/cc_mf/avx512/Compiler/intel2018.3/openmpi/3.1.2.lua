help([==[

Description
===========
The Open MPI Project is an open source MPI-3 implementation.


More information
================
 - Homepage: http://www.open-mpi.org/
]==])

whatis([==[Description: The Open MPI Project is an open source MPI-3 implementation.]==])
whatis([==[Homepage: http://www.open-mpi.org/]==])

local root = "/cvmfs/soft.computecanada.ca/easybuild/software/2017/avx512/Compiler/intel2018.3/openmpi/3.1.2"

conflict("openmpi")
local mroot = os.getenv("MODULEPATH_ROOT")
prepend_path("MODULEPATH", pathJoin(mroot,"avx512/MPI/intel2018.3/openmpi3.1"))

prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("MANPATH", pathJoin(root, "share/man"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PKG_CONFIG_PATH", pathJoin(root, "lib/pkgconfig"))
setenv("EBROOTOPENMPI", root)
setenv("EBVERSIONOPENMPI", "3.1.2")
setenv("EBDEVELOPENMPI", pathJoin(root, "easybuild/avx512-Compiler-intel2018.3-openmpi-3.1.2-easybuild-devel"))

setenv("SLURM_MPI_TYPE", "pmi2")

setenv("OMPI_MCA_mtl", "^mxm")
if os.getenv("RSNT_INTERCONNECT") == "omnipath" then
        setenv("OMPI_MCA_pml", "^ucx,yalla")
else
        setenv("OMPI_MCA_pml", "^yalla")
end

family("mpi")

-- Built with EasyBuild version 3.7.0

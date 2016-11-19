help([[The Open MPI Project is an open source MPI-2 implementation. - Homepage: http://www.open-mpi.org/]])

whatis([[Description: The Open MPI Project is an open source MPI-2 implementation. - Homepage: http://www.open-mpi.org/]])

local root = "/cvmfs/soft.cc/nix/1/easybuild/generic/software/Compiler/mpi/intel2017.1/openmpi/2.0.1"

conflict("openmpi")

load("icc/.2017.1.132")

load("ifort/.2017.1.132")

local mroot = os.getenv("MROOT_CQ")
prepend_path("MODULEPATH", pathJoin(mroot,"MPI/intel2017.1/openmpi2.0"))

prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("MANPATH", pathJoin(root, "share/man"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PKG_CONFIG_PATH", pathJoin(root, "lib/pkgconfig"))
setenv("EBROOTOPENMPI", root)
setenv("EBVERSIONOPENMPI", "2.0.1")
setenv("EBDEVELOPENMPI", pathJoin(root, "easybuild/Compiler-mpi-intel2017.1-openmpi-2.0.1-easybuild-devel"))

-- Built with EasyBuild version 3.0.0.dev0-r81f50b882092338a620b4a51b5bea0c4a27bbb2b

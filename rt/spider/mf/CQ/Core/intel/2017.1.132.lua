help([[Intel Cluster Toolkit Compiler Edition provides Intel C,C++ and fortran compilers, Intel MPI and Intel MKL - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/]])

whatis([[Description: Intel Cluster Toolkit Compiler Edition provides Intel C,C++ and fortran compilers, Intel MPI and Intel MKL - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/]])

local root = "/cvmfs/soft.cc/nix/1/easybuild/generic/software/Core/iccifort/2017.1.132"

conflict("intel")

load("icc/.2017.1.132")

load("ifort/.2017.1.132")

local mroot = os.getenv("MROOT_CQ")

prepend_path("MODULEPATH", pathJoin(mroot,"Compiler/intel2017.1"))
prepend_path("MODULEPATH", pathJoin(mroot,"Compiler/mpi/intel2017.1"))

setenv("EBROOTICCIFORT", root)
setenv("EBVERSIONICCIFORT", "2017.1.132")
setenv("EBDEVELICCIFORT", pathJoin(root, "easybuild/Core-intel-2017.1.132-easybuild-devel"))


add_property("type_","tools")
family("compiler")

-- Built with EasyBuild version 3.0.0.dev0-r81f50b882092338a620b4a51b5bea0c4a27bbb2b

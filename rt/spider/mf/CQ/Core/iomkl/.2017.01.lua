help([[Intel Cluster Toolchain Compiler Edition provides Intel C/C++ and Fortran compilers, Intel MKL & OpenMPI. - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/]])

whatis([[Description: Intel Cluster Toolchain Compiler Edition provides Intel C/C++ and Fortran compilers, Intel MKL & OpenMPI. - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/]])

local root = "/cvmfs/soft.cc/nix/1/easybuild/generic/software/Core/iomkl/2017.01"

conflict("iomkl")

load("icc/.2017.1.132")

load("ifort/.2017.1.132")

load("intel/2017.1.132")

load("openmpi/2.0.1")

load("imkl/2017.1.132")

setenv("EBROOTIOMKL", root)
setenv("EBVERSIONIOMKL", "2017.01")
setenv("EBDEVELIOMKL", pathJoin(root, "easybuild/Core-iomkl-.2017.01-easybuild-devel"))

-- Built with EasyBuild version 3.0.0.dev0-r81f50b882092338a620b4a51b5bea0c4a27bbb2b

help([[Toolchain with Intel C, C++ and Fortran compilers, alongside OpenMPI. - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/]])

whatis([[Description: Toolchain with Intel C, C++ and Fortran compilers, alongside OpenMPI. - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/]])

local root = "/cvmfs/soft.cc/nix/1/easybuild/generic/software/Core/iompi/2017.01"

conflict("iompi")

load("icc/.2017.1.132")

load("ifort/.2017.1.132")

load("intel/2017.1.132")

load("openmpi/2.0.1")

setenv("EBROOTIOMPI", root)
setenv("EBVERSIONIOMPI", "2017.01")
setenv("EBDEVELIOMPI", pathJoin(root, "easybuild/Core-iompi-.2017.01-easybuild-devel"))

-- Built with EasyBuild version 3.0.0.dev0-r81f50b882092338a620b4a51b5bea0c4a27bbb2b

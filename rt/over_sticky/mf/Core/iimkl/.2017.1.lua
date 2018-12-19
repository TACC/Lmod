help([[Intel C/C++ and Fortran compilers, alongside Intel MKL. - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/]])

whatis([[Description: Intel C/C++ and Fortran compilers, alongside Intel MKL. - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/]])

local root = "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/iimkl/2017.1"

conflict("iimkl")

load("icc/.2017.1.132")

load("ifort/.2017.1.132")

load("intel/2017.1")

load("imkl/2017.1.132")
setenv("EBROOTIIMKL", root)
setenv("EBVERSIONIIMKL", "2017.1")
setenv("EBDEVELIIMKL", pathJoin(root, "easybuild/Core-iimkl-.2017.1-easybuild-devel"))

-- Built with EasyBuild version 3.1.0-rb9ec927fab948052740d84472f0a86c19bddbd87

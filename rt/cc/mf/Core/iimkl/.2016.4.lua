help([[Intel C/C++ and Fortran compilers, alongside Intel MKL. - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/]])

whatis([[Description: Intel C/C++ and Fortran compilers, alongside Intel MKL. - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/]])

local root = "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/iimkl/2016.4"

conflict("iimkl")

load("icc/.2016.4.258")

load("ifort/.2016.4.258")

load("intel/2016.4")

load("imkl/11.3.4.258")

setenv("EBROOTIIMKL", root)
setenv("EBVERSIONIIMKL", "2016.4")
setenv("EBDEVELIIMKL", pathJoin(root, "easybuild/Core-iimkl-.2016.4-easybuild-devel"))

-- Built with EasyBuild version 3.1.0-rb9ec927fab948052740d84472f0a86c19bddbd87

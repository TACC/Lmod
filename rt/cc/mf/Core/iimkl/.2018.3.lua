help([==[

Description
===========
Intel C/C++ and Fortran compilers, alongside Intel MKL.


More information
================
 - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/
]==])

whatis([==[Description: Intel C/C++ and Fortran compilers, alongside Intel MKL.]==])
whatis([==[Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/]==])

local root = "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/iimkl/2018.3"

conflict("iimkl")

depends_on("icc/.2018.3.222")

depends_on("ifort/.2018.3.222")

depends_on("intel/2018.3")

depends_on("imkl/2018.3.222")

setenv("EBROOTIIMKL", root)
setenv("EBVERSIONIIMKL", "2018.3")
setenv("EBDEVELIIMKL", pathJoin(root, "easybuild/Core-iimkl-.2018.3-easybuild-devel"))

-- Built with EasyBuild version 3.7.0-rd87eb096d41e017c8f68296771c685f4d57ba80f

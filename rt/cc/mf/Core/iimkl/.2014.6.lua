help([[

Description
===========
Intel C/C++ and Fortran compilers, alongside Intel MKL.


More information
================
 - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/
]])

whatis([[Description: Intel C/C++ and Fortran compilers, alongside Intel MKL.]])
whatis([[Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/]])

local root = "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/iimkl/2014.6"

conflict("iimkl")

load("icc/.2013_sp1.6.214")

load("ifort/.2013_sp1.6.214")

load("intel/2014.6")

load("imkl/11.1.4.214")

setenv("EBROOTIIMKL", root)
setenv("EBVERSIONIIMKL", "2014.6")
setenv("EBDEVELIIMKL", pathJoin(root, "easybuild/Core-iimkl-.2014.6-easybuild-devel"))

-- Built with EasyBuild version 3.4.0-r1cfcd9fe01574b077a697af46dde323f15abd763

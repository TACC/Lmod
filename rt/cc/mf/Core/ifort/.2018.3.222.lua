help([==[

Description
===========
Intel Fortran compiler


More information
================
 - Homepage: http://software.intel.com/en-us/intel-compilers/
]==])

local root = "/cvmfs/restricted.computecanada.ca/easybuild/software/2017/Core/ifort/2018.3.222"


depends_on("gcccore/.7.3.0")

prepend_path("PATH", pathJoin(root, "compilers_and_libraries_2018.3.222/linux/bin/intel64"))
-- Built with EasyBuild version 3.6.2-r1ed7dac97acd22d6301e534c78048f7fcedaa585

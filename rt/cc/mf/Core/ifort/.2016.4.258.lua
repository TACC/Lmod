help([==[

Description
===========
Fortran compiler from Intel


More information
================
 - Homepage: http://software.intel.com/en-us/intel-compilers/
]==])


local root = "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/ifort/2016.4.258"

depends_on("gcccore/.5.4.0")

prepend_path("PATH", pathJoin(root, "compilers_and_libraries_2016.4.258/linux/bin/intel64"))
-- Built with EasyBuild version 3.5.0-r9c88db64dba51c4ffd22799c06090d57aaf17e38

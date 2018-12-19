help([[

Description
===========
Fortran compiler from Intel


More information
================
 - Homepage: http://software.intel.com/en-us/intel-compilers/
]])

whatis([[Description: Fortran compiler from Intel]])
whatis([[Homepage: http://software.intel.com/en-us/intel-compilers/]])

local root = "/cvmfs/restricted.computecanada.ca/easybuild/software/2017/Core/ifort/2013_sp1.6.214"

conflict("ifort")

load("gcccore/.4.8.5")

prepend_path("LIBRARY_PATH", pathJoin(root, "composer_xe_2013_sp1.6.214/compiler/lib/intel64"))
prepend_path("MANPATH", pathJoin(root, "composer_xe_2013_sp1.6.214/man/en_US"))
prepend_path("PATH", pathJoin(root, "composer_xe_2013_sp1.6.214/bin/intel64"))
setenv("EBROOTIFORT", root)
setenv("EBVERSIONIFORT", "2013_sp1.6.214")
setenv("EBDEVELIFORT", pathJoin(root, "easybuild/Core-ifort-.2013_sp1.6.214-easybuild-devel"))


prepend_path("LIBRARY_PATH", pathJoin(root:gsub("/restricted.computecanada.ca/","/soft.computecanada.ca/"), "composer_xe_2013_sp1.6.214/compiler/lib/intel64"))

prepend_path("NLSPATH", pathJoin(root, "idb/intel64/locale/%l_%t/%N"))
-- Built with EasyBuild version 3.4.0-r56679e9852975a447aff299fbc2903023c3bb057

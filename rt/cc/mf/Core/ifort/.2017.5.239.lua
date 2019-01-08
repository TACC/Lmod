help([==[

Description
===========
Fortran compiler from Intel


More information
================
 - Homepage: http://software.intel.com/en-us/intel-compilers/
]==])

whatis([==[Description: Fortran compiler from Intel]==])
whatis([==[Homepage: http://software.intel.com/en-us/intel-compilers/]==])

local root = "/cvmfs/restricted.computecanada.ca/easybuild/software/2017/Core/ifort/2017.5.239"

conflict("ifort")

depends_on("gcccore/.6.4.0")

prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LIBRARY_PATH", pathJoin(root, "compilers_and_libraries_2017.5.239/linux/compiler/lib/intel64"))
prepend_path("MANPATH", pathJoin(root, "compilers_and_libraries_2017.5.239/linux/man/common"))
prepend_path("PATH", pathJoin(root, "compilers_and_libraries_2017.5.239/linux/bin/intel64"))
setenv("EBROOTIFORT", root)
setenv("EBVERSIONIFORT", "2017.5.239")
setenv("EBDEVELIFORT", pathJoin(root, "easybuild/Core-ifort-.2017.5.239-easybuild-devel"))


prepend_path("LIBRARY_PATH", pathJoin(root:gsub("/restricted.computecanada.ca/","/soft.computecanada.ca/"), "compilers_and_libraries_2017.5.239/linux/compiler/lib/intel64"))

prepend_path("NLSPATH", pathJoin(root, "idb/intel64/locale/%l_%t/%N"))
-- Built with EasyBuild version 3.6.1-r7cc8e8f5644ea63bcb902c6179dcffbb89cac49a

help([[

Description
===========
C and C++ compiler from Intel


More information
================
 - Homepage: http://software.intel.com/en-us/intel-compilers/
]])

whatis([[Description: C and C++ compiler from Intel]])
whatis([[Homepage: http://software.intel.com/en-us/intel-compilers/]])

local root = "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/icc/2017.1.132"

conflict("icc")

load("gcccore/.5.4.0")

prepend_path("LIBRARY_PATH", pathJoin(root, "compilers_and_libraries_2017.1.132/linux/compiler/lib/intel64"))
prepend_path("MANPATH", pathJoin(root, "compilers_and_libraries_2017.1.132/linux/man/common"))
prepend_path("PATH", pathJoin(root, "compilers_and_libraries_2017.1.132/linux/bin/intel64"))
setenv("EBROOTICC", root)
setenv("EBVERSIONICC", "2017.1.132")
setenv("EBDEVELICC", pathJoin(root, "easybuild/Core-icc-.2017.1.132-easybuild-devel"))

prepend_path("NLSPATH", pathJoin(root, "idb/intel64/locale/%l_%t/%N"))
-- Built with EasyBuild version 3.3.1-r2ae5e35acbe89708e87b77adf5ee4b96a9830f50

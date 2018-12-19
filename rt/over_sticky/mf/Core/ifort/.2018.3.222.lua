help([==[

Description
===========
Intel Fortran compiler


More information
================
 - Homepage: http://software.intel.com/en-us/intel-compilers/
]==])

whatis([==[Description: Intel Fortran compiler]==])
whatis([==[Homepage: http://software.intel.com/en-us/intel-compilers/]==])

local root = "/cvmfs/restricted.computecanada.ca/easybuild/software/2017/Core/ifort/2018.3.222"

conflict("ifort")

depends_on("gcccore/.7.3.0")

prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LIBRARY_PATH", pathJoin(root, "compilers_and_libraries_2018.3.222/linux/compiler/lib/intel64"))
prepend_path("MANPATH", pathJoin(root, "compilers_and_libraries_2018.3.222/linux/man/common"))
prepend_path("PATH", pathJoin(root, "compilers_and_libraries_2018.3.222/linux/bin/intel64"))
setenv("EBROOTIFORT", root)
setenv("EBVERSIONIFORT", "2018.3.222")
setenv("EBDEVELIFORT", pathJoin(root, "easybuild/Core-ifort-.2018.3.222-easybuild-devel"))


prepend_path("LIBRARY_PATH", pathJoin(root:gsub("/restricted.computecanada.ca/","/soft.computecanada.ca/"), "compilers_and_libraries_2018.3.222/linux/compiler/lib/intel64"))

prepend_path("NLSPATH", pathJoin(root, "idb/intel64/locale/%l_%t/%N"))
setenv("INTEL_PYTHONHOME", "/cvmfs/restricted.computecanada.ca/easybuild/software/2017/Core/ifort/2018.3.222/debugger_2018/python/intel64")
-- Built with EasyBuild version 3.6.2-r1ed7dac97acd22d6301e534c78048f7fcedaa585

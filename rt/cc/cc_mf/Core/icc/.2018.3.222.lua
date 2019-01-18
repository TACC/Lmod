help([==[

Description
===========
Intel C and C++ compilers


More information
================
 - Homepage: http://software.intel.com/en-us/intel-compilers/
]==])

whatis([==[Description: Intel C and C++ compilers]==])
whatis([==[Homepage: http://software.intel.com/en-us/intel-compilers/]==])

local root = "/cvmfs/restricted.computecanada.ca/easybuild/software/2017/Core/icc/2018.3.222"

conflict("icc")

depends_on("gcccore/.7.3.0")

prepend_path("CPATH", pathJoin(root, "compilers_and_libraries_2018.3.222/linux/tbb/include"))
prepend_path("LIBRARY_PATH", pathJoin(root, "compilers_and_libraries_2018.3.222/linux/compiler/lib/intel64"))
prepend_path("LIBRARY_PATH", pathJoin(root, "compilers_and_libraries_2018.3.222/linux/tbb/lib/intel64/gcc4.4"))
prepend_path("MANPATH", pathJoin(root, "compilers_and_libraries_2018.3.222/linux/man/common"))
prepend_path("PATH", pathJoin(root, "compilers_and_libraries_2018.3.222/linux/bin/intel64"))
prepend_path("TBBROOT", pathJoin(root, "compilers_and_libraries_2018.3.222/linux/tbb"))
setenv("EBROOTICC", root)
setenv("EBVERSIONICC", "2018.3.222")
setenv("EBDEVELICC", pathJoin(root, "easybuild/Core-icc-.2018.3.222-easybuild-devel"))


prepend_path("LIBRARY_PATH", pathJoin(root:gsub("/restricted.computecanada.ca/","/soft.computecanada.ca/"), "compilers_and_libraries_2018.3.222/linux/compiler/lib/intel64"))

prepend_path("NLSPATH", pathJoin(root, "idb/intel64/locale/%l_%t/%N"))
setenv("INTEL_PYTHONHOME", "/cvmfs/restricted.computecanada.ca/easybuild/software/2017/Core/icc/2018.3.222/debugger_2018/python/intel64")
-- Built with EasyBuild version 3.6.2-r1ed7dac97acd22d6301e534c78048f7fcedaa585

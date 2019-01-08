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

local root = "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/ifort/2016.4.258"

conflict("ifort")

if not isloaded("gcccore/.5.4.0") or mode() == "unload" then
    load("gcccore/.5.4.0")
end

prepend_path("LIBRARY_PATH", pathJoin(root, "compilers_and_libraries_2016.4.258/linux/compiler/lib/intel64"))
prepend_path("MANPATH", pathJoin(root, "compilers_and_libraries_2016.4.258/linux/man/common"))
prepend_path("PATH", pathJoin(root, "compilers_and_libraries_2016.4.258/linux/bin/intel64"))
setenv("EBROOTIFORT", root)
setenv("EBVERSIONIFORT", "2016.4.258")
setenv("EBDEVELIFORT", pathJoin(root, "easybuild/Core-ifort-.2016.4.258-easybuild-devel"))

prepend_path("NLSPATH", pathJoin(root, "idb/intel64/locale/%l_%t/%N"))
-- Built with EasyBuild version 3.5.0-r9c88db64dba51c4ffd22799c06090d57aaf17e38

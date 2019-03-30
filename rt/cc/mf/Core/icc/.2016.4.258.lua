help([==[

Description
===========
C and C++ compiler from Intel


More information
================
 - Homepage: http://software.intel.com/en-us/intel-compilers/
]==])

if not isloaded("gcccore/.5.4.0") or mode() == "unload" then
    load("gcccore/.5.4.0")
end

prepend_path("PATH", pathJoin(root, "compilers_and_libraries_2016.4.258/linux/bin/intel64"))
-- Built with EasyBuild version 3.5.0-r9c88db64dba51c4ffd22799c06090d57aaf17e38

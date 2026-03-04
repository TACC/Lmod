help([==[

Description
===========
The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Java, and Ada,
 as well as libraries for these languages (libstdc++, libgcj,...).


More information
================
 - Homepage: https://gcc.gnu.org/
]==])

whatis([==[Description: The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Java, and Ada,
 as well as libraries for these languages (libstdc++, libgcj,...).]==])
whatis([==[Homepage: https://gcc.gnu.org/]==])
whatis([==[URL: https://gcc.gnu.org/]==])

local root = "/hpc2n/eb/software/GCCcore/13.3.0"

conflict("GCCcore")
local mroot = os.getenv("MODULEPATH_ROOT") or ""
prepend_path("MODULEPATH", pathJoin(mroot, "Compiler", "GCCcore", "13.3.0"))
if isDir(pathJoin(os.getenv("HOME") or "HOME_NOT_DEFINED", pathJoin("easybuild/modules", "all", "Compiler/GCCcore/13.3.0"))) then
    prepend_path("MODULEPATH", pathJoin(os.getenv("HOME") or "HOME_NOT_DEFINED", pathJoin("easybuild/modules", "all", "Compiler/GCCcore/13.3.0")))
end
if isDir(pathJoin(os.getenv("PROJECT") or "PROJECT_NOT_DEFINED", pathJoin("easybuild/modules", "all", "Compiler/GCCcore/13.3.0"))) then
    prepend_path("MODULEPATH", pathJoin(os.getenv("PROJECT") or "PROJECT_NOT_DEFINED", pathJoin("easybuild/modules", "all", "Compiler/GCCcore/13.3.0")))
end

prepend_path("CMAKE_LIBRARY_PATH", pathJoin(root, "lib64"))
prepend_path("CMAKE_PREFIX_PATH", root)
prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib64"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib64"))
prepend_path("MANPATH", pathJoin(root, "share", "man"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("XDG_DATA_DIRS", pathJoin(root, "share"))
setenv("EBROOTGCCCORE", root)
setenv("EBVERSIONGCCCORE", "13.3.0")
setenv("EBDEVELGCCCORE", pathJoin(root, "easybuild", "Core-GCCcore-13.3.0-easybuild-devel"))

-- Built with EasyBuild version 5.2.1.dev0-r2a57715d12a949ec500e465bc09d036add3c93d2

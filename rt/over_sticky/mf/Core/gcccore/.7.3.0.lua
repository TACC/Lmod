help([==[

Description
===========
The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Java, and Ada,
 as well as libraries for these languages (libstdc++, libgcj,...).


More information
================
 - Homepage: http://gcc.gnu.org/
]==])

whatis([==[Description: The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Java, and Ada,
 as well as libraries for these languages (libstdc++, libgcj,...).]==])
whatis([==[Homepage: http://gcc.gnu.org/]==])

local root = "/cvmfs/soft.computecanada.ca/nix/var/nix/profiles/gcc-7.3.0"

conflict("gcccore")

prepend_path("CPATH", pathJoin(root, "include"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib64"))
prepend_path("MANPATH", pathJoin(root, "share/man"))
prepend_path("PATH", pathJoin(root, "bin"))
setenv("EBROOTGCCCORE", root)
setenv("EBVERSIONGCCCORE", "7.3.0")
setenv("EBDEVELGCCCORE", pathJoin(root, "easybuild/Core-gcccore-.7.3.0-easybuild-devel"))

prepend_path("CPLUS_INCLUDE_PATH", pathJoin(root, "include/c++/7.3.0"))
-- Built with EasyBuild version 3.5.1-rc1513f470261f1a4fa90a8ef6bd472f15ba085ed

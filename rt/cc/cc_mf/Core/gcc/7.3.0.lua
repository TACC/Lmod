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

local root = "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/gcc/7.3.0"

conflict("gcc")

if not isloaded("gcccore/.7.3.0") or mode() == "unload" then
    load("gcccore/.7.3.0")
end

setenv("EBROOTGCC", "/cvmfs/soft.computecanada.ca/nix/var/nix/profiles/gcc-7.3.0")
setenv("EBVERSIONGCC", "7.3.0")
setenv("EBDEVELGCC", pathJoin(root, "easybuild/Core-gcc-7.3.0-easybuild-devel"))

local mroot = os.getenv("MODULEPATH_ROOT")

prepend_path("MODULEPATH", pathJoin(mroot, os.getenv("RSNT_ARCH"), "Compiler/gcc7.3"))

family("compiler")

-- Built with EasyBuild version 3.5.1-rc1513f470261f1a4fa90a8ef6bd472f15ba085ed

help([[

Description
===========
The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Java, and Ada,
 as well as libraries for these languages (libstdc++, libgcj,...).


More information
================
 - Homepage: http://gcc.gnu.org/
]])

whatis([[Description: The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Java, and Ada,
 as well as libraries for these languages (libstdc++, libgcj,...).]])
whatis([[Homepage: http://gcc.gnu.org/]])

local root = "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/gcc/5.4.0"

conflict("gcc")

load("gcccore/.5.4.0")

setenv("EBROOTGCC", root)
setenv("EBVERSIONGCC", "5.4.0")
setenv("EBDEVELGCC", pathJoin(root, "easybuild/Core-gcc-5.4.0-easybuild-devel"))


local mroot = os.getenv("MODULEPATH_ROOT")
prepend_path("MODULEPATH", pathJoin(mroot, os.getenv("RSNT_ARCH"), "Compiler/gcc5.4"))

family("compiler")

-- Built with EasyBuild version 3.3.0-re50b70af25207aec9b965a5c4aaa47ba992c9aa6

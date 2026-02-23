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

local root = "/hpc2n/eb/software/GCC/12.3.0"

conflict("GCC")

depends_on("GCCcore/12.3.0")

-- depends_on("binutils/2.40")  -- omitted in minimal test tree
local mroot = os.getenv("MODULEPATH_ROOT") or ""
prepend_path("MODULEPATH", pathJoin(mroot, "Compiler", "GCC", "12.3.0"))
if isDir(pathJoin(os.getenv("HOME") or "HOME_NOT_DEFINED", pathJoin("easybuild/modules", "all", "Compiler/GCC/12.3.0"))) then
    prepend_path("MODULEPATH", pathJoin(os.getenv("HOME") or "HOME_NOT_DEFINED", pathJoin("easybuild/modules", "all", "Compiler/GCC/12.3.0")))
end
if isDir(pathJoin(os.getenv("PROJECT") or "PROJECT_NOT_DEFINED", pathJoin("easybuild/modules", "all", "Compiler/GCC/12.3.0"))) then
    prepend_path("MODULEPATH", pathJoin(os.getenv("PROJECT") or "PROJECT_NOT_DEFINED", pathJoin("easybuild/modules", "all", "Compiler/GCC/12.3.0")))
end

setenv("EBROOTGCC", "/hpc2n/eb/software/GCCcore/12.3.0")
setenv("EBVERSIONGCC", "12.3.0")
setenv("EBDEVELGCC", pathJoin(root, "easybuild/Core-GCC-12.3.0-easybuild-devel"))

-- Built with EasyBuild version 4.8.1

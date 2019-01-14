help([[

Description
===========
The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Java, and Ada,
 as well as libraries for these languages (libstdc++, libgcj,...).


More information
================
 - Homepage: http://gcc.gnu.org/
]])

local root = "/cvmfs/soft.computecanada.ca/nix/var/nix/profiles/gcc-5.4.0"

prepend_path("PATH", pathJoin(root, "bin"))
-- Built with EasyBuild version 3.3.0-re50b70af25207aec9b965a5c4aaa47ba992c9aa6

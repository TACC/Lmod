help([==[

Description
===========
Intel C, C++ & Fortran compilers


More information
================
 - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/
]==])
depends_on("icc/.2018.3.222")

depends_on("ifort/.2018.3.222")

if isloaded("imkl") then
    always_load("imkl/2018.3.222")
end
family("compiler")

-- Built with EasyBuild version 3.7.0-rc7b39e420d4f1af2b79028319dfd5ed90b504390

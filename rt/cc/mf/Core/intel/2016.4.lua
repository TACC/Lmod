help([==[

Description
===========
Intel Cluster Toolkit Compiler Edition provides Intel C,C++ and fortran compilers, Intel MPI and Intel MKL


More information
================
 - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/
]==])

depends_on("icc/.2016.4.258")

depends_on("ifort/.2016.4.258")

if isloaded("imkl") then
    always_load("imkl/11.3.4.258")
end

family("compiler")

-- Built with EasyBuild version 3.5.0-r9c88db64dba51c4ffd22799c06090d57aaf17e38

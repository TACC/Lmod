help([==[

Description
===========
Intel Cluster Toolkit Compiler Edition provides Intel C,C++ and fortran compilers, Intel MPI and Intel MKL


More information
================
 - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/
]==])

whatis([==[Description: Intel Cluster Toolkit Compiler Edition provides Intel C,C++ and fortran compilers, Intel MPI and Intel MKL]==])
whatis([==[Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/]==])

local root = "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/intel/2017.1"

conflict("intel")

if not isloaded("icc/.2017.1.132") or mode() == "unload" then
    load("icc/.2017.1.132")
end

if not isloaded("ifort/.2017.1.132") or mode() == "unload" then
    load("ifort/.2017.1.132")
end

setenv("EBROOTICCIFORT", root)
setenv("EBVERSIONICCIFORT", "2017.1")
setenv("EBDEVELICCIFORT", pathJoin(root, "easybuild/Core-intel-2017.1-easybuild-devel"))


if isloaded("imkl") then
    always_load("imkl/2017.1.132")
end

prepend_path("INTEL_LICENSE_FILE", pathJoin("/cvmfs/soft.computecanada.ca/config/licenses/intel", os.getenv("CC_CLUSTER") .. ".lic"))

prepend_path("MODULEPATH", pathJoin("/cvmfs/soft.computecanada.ca/easybuild/modules/2017", os.getenv("RSNT_ARCH"), "Compiler/intel2017.1"))
if isDir(pathJoin(os.getenv("HOME"), ".local/easybuild/modules/2017", os.getenv("RSNT_ARCH"), "Compiler/intel2017.1")) then
    prepend_path("MODULEPATH", pathJoin(os.getenv("HOME"), ".local/easybuild/modules/2017", os.getenv("RSNT_ARCH"), "Compiler/intel2017.1"))
end

--add_property("type_","tools")
family("compiler")

-- Built with EasyBuild version 3.5.0-r9c88db64dba51c4ffd22799c06090d57aaf17e38

help([==[

Description
===========
Intel C, C++ & Fortran compilers


More information
================
 - Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/
]==])

whatis([==[Description: Intel C, C++ & Fortran compilers]==])
whatis([==[Homepage: http://software.intel.com/en-us/intel-cluster-toolkit-compiler/]==])

local root = "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/intel/2018.3"

conflict("intel")

depends_on("icc/.2018.3.222")

depends_on("ifort/.2018.3.222")

setenv("EBROOTICCIFORT", root)
setenv("EBVERSIONICCIFORT", "2018.3")
setenv("EBDEVELICCIFORT", pathJoin(root, "easybuild/Core-intel-2018.3-easybuild-devel"))


prepend_path("INTEL_LICENSE_FILE", pathJoin("/cvmfs/soft.computecanada.ca/config/licenses/intel", os.getenv("CC_CLUSTER") .. ".lic"))

prepend_path("MODULEPATH", pathJoin("/cvmfs/soft.computecanada.ca/easybuild/modules/2017", os.getenv("RSNT_ARCH"), "Compiler/intel2018.3"))
if isDir(pathJoin(os.getenv("HOME"), ".local/easybuild/modules/2017", os.getenv("RSNT_ARCH"), "Compiler/intel2018.3")) then
    prepend_path("MODULEPATH", pathJoin(os.getenv("HOME"), ".local/easybuild/modules/2017", os.getenv("RSNT_ARCH"), "Compiler/intel2018.3"))
end

if isloaded("imkl") then
    always_load("imkl/2018.3.222")
end

--add_property("type_","tools")
family("compiler")

-- Built with EasyBuild version 3.7.0-rc7b39e420d4f1af2b79028319dfd5ed90b504390

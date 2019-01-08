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


setenv("EBROOTICCIFORT", root)
setenv("EBVERSIONICCIFORT", "2018.3")
setenv("EBDEVELICCIFORT", pathJoin(root, "easybuild/Core-intel-2018.3-easybuild-devel"))

--add_property("type_","tools")
family("compiler")

-- Built with EasyBuild version 3.7.0-rc7b39e420d4f1af2b79028319dfd5ed90b504390

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

local root = "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/intel/2016.4"

setenv("EBROOTICCIFORT", root)
setenv("EBVERSIONICCIFORT", "2016.4")
setenv("EBDEVELICCIFORT", pathJoin(root, "easybuild/Core-intel-2016.4-easybuild-devel"))

--add_property("type_","tools")
family("compiler")

-- Built with EasyBuild version 3.5.0-r9c88db64dba51c4ffd22799c06090d57aaf17e38

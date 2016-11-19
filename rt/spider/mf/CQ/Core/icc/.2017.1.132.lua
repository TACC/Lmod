help([[C and C++ compiler from Intel - Homepage: http://software.intel.com/en-us/intel-compilers/]])

whatis([[Description: C and C++ compiler from Intel - Homepage: http://software.intel.com/en-us/intel-compilers/]])

local root = "/cvmfs/soft.cc/nix/1/easybuild/generic/software/Core/icc/2017.1.132"

conflict("icc")

prepend_path("IDB_HOME", pathJoin(root, "compilers_and_libraries_2017.1.132/linux/bin/intel64"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib/intel64"))
prepend_path("LIBRARY_PATH", pathJoin(root, "compilers_and_libraries_2017.1.132/linux/compiler/lib/intel64"))
prepend_path("LIBRARY_PATH", pathJoin(root, "compilers_and_libraries_2017.1.132/linux/compiler/lib/intel64"))
prepend_path("MANPATH", pathJoin(root, "man"))
prepend_path("MANPATH", pathJoin(root, "man/common"))
prepend_path("MANPATH", pathJoin(root, "compilers_and_libraries_2017.1.132/linux/man"))
prepend_path("MANPATH", pathJoin(root, "compilers_and_libraries_2017.1.132/linux/man/common"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PATH", pathJoin(root, "compilers_and_libraries_2017.1.132/linux/bin"))
prepend_path("PATH", pathJoin(root, "compilers_and_libraries_2017.1.132/linux/bin/intel64"))
setenv("EBROOTICC", root)
setenv("EBVERSIONICC", "2017.1.132")
setenv("EBDEVELICC", pathJoin(root, "easybuild/Core-icc-.2017.1.132-easybuild-devel"))

prepend_path("INTEL_LICENSE_FILE", "40835@license1.computecanada.ca")
prepend_path("NLSPATH", pathJoin(root, "idb/intel64/locale/%l_%t/%N"))
-- Built with EasyBuild version 3.0.0.dev0-r81f50b882092338a620b4a51b5bea0c4a27bbb2b

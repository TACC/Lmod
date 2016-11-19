help([[Intel Math Kernel Library is a library of highly optimized,
 extensively threaded math routines for science, engineering, and financial
 applications that require maximum performance. Core math functions include
 BLAS, LAPACK, ScaLAPACK, Sparse Solvers, Fast Fourier Transforms, Vector Math, and more. - Homepage: http://software.intel.com/en-us/intel-mkl/]])

whatis([[Description: Intel Math Kernel Library is a library of highly optimized,
 extensively threaded math routines for science, engineering, and financial
 applications that require maximum performance. Core math functions include
 BLAS, LAPACK, ScaLAPACK, Sparse Solvers, Fast Fourier Transforms, Vector Math, and more. - Homepage: http://software.intel.com/en-us/intel-mkl/]])

local root = "/cvmfs/soft.cc/nix/1/easybuild/generic/software/MPI/intel2017.1/openmpi2.0/imkl/2017.1.132"

conflict("imkl")

load("icc/.2017.1.132")

load("ifort/.2017.1.132")

prepend_path("CPATH", pathJoin(root, "mkl/include"))
prepend_path("CPATH", pathJoin(root, "mkl/include/fftw"))
prepend_path("FPATH", pathJoin(root, "mkl/include"))
prepend_path("FPATH", pathJoin(root, "mkl/include/fftw"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib/intel64"))
prepend_path("LIBRARY_PATH", pathJoin(root, "mkl/lib/intel64"))
prepend_path("MIC_LD_LIBRARY_PATH", pathJoin(root, "lib/intel64_lin_mic"))
prepend_path("MIC_LD_LIBRARY_PATH", pathJoin(root, "mkl/lib/mic"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PATH", pathJoin(root, "mkl/bin"))
setenv("EBROOTIMKL", root)
setenv("EBVERSIONIMKL", "2017.1.132")
setenv("EBDEVELIMKL", pathJoin(root, "easybuild/MPI-intel2017.1-openmpi2.0-imkl-2017.1.132-easybuild-devel"))

setenv("MKL_EXAMPLES", "/cvmfs/soft.cc/nix/1/easybuild/generic/software/MPI/intel2017.1/openmpi2.0/imkl/2017.1.132/mkl/examples/")
prepend_path("INTEL_LICENSE_FILE", "40835@license1.computecanada.ca")
prepend_path("NLSPATH", pathJoin(root, "idb/intel64/locale/%l_%t/%N"))
setenv("MKLROOT", "/cvmfs/soft.cc/nix/1/easybuild/generic/software/MPI/intel2017.1/openmpi2.0/imkl/2017.1.132/mkl")
-- Built with EasyBuild version 3.0.0.dev0-r81f50b882092338a620b4a51b5bea0c4a27bbb2b

help([==[

Description
===========
Intel Math Kernel Library is a library of highly optimized,
 extensively threaded math routines for science, engineering, and financial
 applications that require maximum performance. Core math functions include
 BLAS, LAPACK, ScaLAPACK, Sparse Solvers, Fast Fourier Transforms, Vector Math, and more.


More information
================
 - Homepage: http://software.intel.com/en-us/intel-mkl/
]==])

whatis([==[Description: Intel Math Kernel Library is a library of highly optimized,
 extensively threaded math routines for science, engineering, and financial
 applications that require maximum performance. Core math functions include
 BLAS, LAPACK, ScaLAPACK, Sparse Solvers, Fast Fourier Transforms, Vector Math, and more.]==])
whatis([==[Homepage: http://software.intel.com/en-us/intel-mkl/]==])

local root = "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/imkl/2017.1.132"

conflict("imkl")

prepend_path("CPATH", pathJoin(root, "mkl/include"))
prepend_path("CPATH", pathJoin(root, "mkl/include/fftw"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib/intel64"))
prepend_path("LIBRARY_PATH", pathJoin(root, "mkl/lib/intel64"))
prepend_path("MIC_LD_LIBRARY_PATH", pathJoin(root, "lib/intel64_lin_mic"))
prepend_path("MIC_LD_LIBRARY_PATH", pathJoin(root, "mkl/lib/mic"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PATH", pathJoin(root, "mkl/bin"))
setenv("EBROOTIMKL", root)
setenv("EBVERSIONIMKL", "2017.1.132")
setenv("EBDEVELIMKL", pathJoin(root, "easybuild/Core-imkl-2017.1.132-easybuild-devel"))

setenv("MKL_ENABLE_INSTRUCTIONS", "AVX512")
setenv("MKL_EXAMPLES", "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/imkl/2017.1.132/mkl/examples/")
prepend_path("NLSPATH", pathJoin(root, "idb/intel64/locale/%l_%t/%N"))
setenv("MKLROOT", "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/imkl/2017.1.132/mkl")
-- Built with EasyBuild version 3.6.2-r7ac096157987d9f8fad6490e41038c31790fa6ee

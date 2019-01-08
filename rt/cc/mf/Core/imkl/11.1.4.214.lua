help([[

Description
===========
Intel Math Kernel Library is a library of highly optimized,
 extensively threaded math routines for science, engineering, and financial
 applications that require maximum performance. Core math functions include
 BLAS, LAPACK, ScaLAPACK, Sparse Solvers, Fast Fourier Transforms, Vector Math, and more.


More information
================
 - Homepage: http://software.intel.com/en-us/intel-mkl/
]])

whatis([[Description: Intel Math Kernel Library is a library of highly optimized,
 extensively threaded math routines for science, engineering, and financial
 applications that require maximum performance. Core math functions include
 BLAS, LAPACK, ScaLAPACK, Sparse Solvers, Fast Fourier Transforms, Vector Math, and more.]])
whatis([[Homepage: http://software.intel.com/en-us/intel-mkl/]])

local root = "/cvmfs/restricted.computecanada.ca/easybuild/software/2017/Core/imkl/11.1.4.214"

conflict("imkl")

prepend_path("CPATH", pathJoin(root, "mkl/include"))
prepend_path("CPATH", pathJoin(root, "mkl/include/fftw"))
prepend_path("LIBRARY_PATH", pathJoin(root, "lib/intel64"))
prepend_path("LIBRARY_PATH", pathJoin(root, "mkl/lib/intel64"))
prepend_path("MIC_LD_LIBRARY_PATH", pathJoin(root, "mkl/lib/mic"))
prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PATH", pathJoin(root, "mkl/bin"))
prepend_path("PATH", pathJoin(root, "mkl/bin/intel64"))
setenv("EBROOTIMKL", root)
setenv("EBVERSIONIMKL", "11.1.4.214")
setenv("EBDEVELIMKL", pathJoin(root, "easybuild/Core-imkl-11.1.4.214-easybuild-devel"))

setenv("MKL_EXAMPLES", "/cvmfs/restricted.computecanada.ca/easybuild/software/2017/Core/imkl/11.1.4.214/mkl/examples/")

prepend_path("LIBRARY_PATH", pathJoin(root:gsub("/restricted.computecanada.ca/","/soft.computecanada.ca/"), "mkl/lib/intel64"))

prepend_path("NLSPATH", pathJoin(root, "idb/intel64/locale/%l_%t/%N"))
setenv("MKLROOT", "/cvmfs/restricted.computecanada.ca/easybuild/software/2017/Core/imkl/11.1.4.214/mkl")
-- Built with EasyBuild version 3.4.0-r56679e9852975a447aff299fbc2903023c3bb057

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


local root = "/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/imkl/11.3.4.258"

prepend_path("PATH", pathJoin(root, "bin"))
prepend_path("PATH", pathJoin(root, "mkl/bin"))
-- Built with EasyBuild version 3.6.2-r7ac096157987d9f8fad6490e41038c31790fa6ee

local help_msg=[[
Intel compilers 19.0.5 produce optimized code that can run significantly
faster by taking advantage of the ever increasing core count and vector
register width in Intel Xeon processors, Intel Xeon Phi coprocessors and
compatible processors. The Intel compilers plug right into popular development
environments and are compatible with compilers including GCC (Linux).

The Intel module enables the Intel family of compilers (C/C++ and Fortran) and
updates the $PATH, $LD_LIBRARY_PATH, $INCLUDE, and $MANPATH environment
variables to access the compiler binaries, libraries, include files, and
available man pages, respectively.

The following additional environment variables are also defined:

$ICC_BIN                (path to icc/icpc compilers          )
$ICC_LIB                (path to C/C++  libraries            )
$IFC_BIN                (path to ifort compiler              )
$IFC_LIB                (path to Fortran libraries           )
$TACC_MKL_DIR           (path to Math Kernel Library root    )
$TACC_MKL_LIB           (path to Math Kernel Library libs    )
$TACC_MKL_INC           (path to Math Kernel Library includes)

In general, users need only to add the "-mkl" flag during compile and link time
to utlize thei Math Kernel Library provided by Intel.  This includes any calls
to BLAS and LAPACK functions.
 
See the man pages for icc, icpc, and ifort for detailed information on
available compiler options and command-line syntax.

Note: To provide C++11/14/17 support for the Intel compiler, this module adds the
paths for the gcc/8.3.0 bin, lib, and lib64 directories to your environment.

Note: The $TACC_VEC_FLAGS environment variable is provided as a convenience
during your compliation step. This variable specifies instruction sets
appropriate to build and run on any Frontera node (login node, KNL compute
node, SKX compute node), and use CPU dispatch to produce a multi-architecture
binary.

The INTEL module also defines the following environment variables:
TACC_INTEL_DIR, TACC_INTEL_LIB, TACC_INTEL_INC and
TACC_INTEL_BIN for the location of the INTEL distribution,
libraries, include files, and tools respectively.

Version 19.0.5
]]

help(help_msg)

whatis("Name: Intel Compiler"                                               )
whatis("Version: 19.0.5"                                                )
whatis("Category: compiler, Runtime Support"                                )
whatis("Description: Intel Compiler Family (C/C++/Fortran for x86_64)"      )
whatis("URL: http://software.intel.com/en-us/articles/intel-compilers"      )

-- Create environment variables.
local base         = "/opt/intel"
local gcc_base     = "/opt/apps/gcc/8.3.0"
local full_xe      = "compilers_and_libraries_2019.5.281/linux"
local arch         = "intel64"
local installDir   = pathJoin(base,full_xe)
local tbbRoot      = pathJoin(installDir,"tbb")
local mklRoot      = pathJoin(installDir,"mkl")
local ippRoot      = pathJoin(installDir,"ipp")
local daalRoot     = pathJoin(installDir,"daal")
local pstlRoot     = pathJoin(installDir,"pstl")


setenv( "MKLROOT"      ,                  mklRoot )
setenv( "TACC_MKL_DIR" ,                  mklRoot )
setenv( "TACC_MKL_LIB" ,              pathJoin( mklRoot , "lib/intel64" ) )
setenv( "TACC_MKL_INC" ,              pathJoin( mklRoot , "include"     ) )

--MKLROOT=
--/opt/intel/compilers_and_libraries_2019.4.243/linux/mkl

prepend_path( "MANPATH" ,             pathJoin( base ,       "documentation_2019/en/debugger/gdb-ia/man"   ) )
prepend_path( "MANPATH" ,             pathJoin( base ,       "documentation_2019/en/man/common"            ) )

--MANPATH=
-- /opt/intel/documentation_2018/en/debugger//gdb-ia/man
-- /opt/intel/documentation_2018/en/man/common

local home = os.getenv("HOME")

prepend_path( "INTEL_LICENSE_FILE" ,  pathJoin( installDir , "licenses"       ) )
prepend_path( "INTEL_LICENSE_FILE" ,  pathJoin( base       , "licenses"       ) )
prepend_path( "INTEL_LICENSE_FILE" ,  pathJoin( home       , "intel/licenses" ) )

--INTEL_LICENSE_FILE=
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/licenses
-- /opt/intel/licenses
-- ${HOME}/intel/licenses

setenv( "IPPROOT" ,                   ippRoot )
--IPPROOT=
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/ipp

prepend_path( "LIBRARY_PATH" ,        pathJoin( installDir , "compiler/lib/intel64_lin"            ) )
prepend_path( "LIBRARY_PATH" ,        pathJoin( installDir , "ipp/lib/intel64"                     ) )
prepend_path( "LIBRARY_PATH" ,        pathJoin( installDir , "mkl/lib/intel64_lin"                 ) )
prepend_path( "LIBRARY_PATH" ,        pathJoin( installDir , "tbb/lib/intel64/gcc4.7"              ) )
prepend_path( "LIBRARY_PATH" ,        pathJoin( installDir , "daal/lib/intel64_lin"                ) )
prepend_path( "LIBRARY_PATH" ,        pathJoin( base       , "debugger_2019/libipt/intel64/lib" ) )

--LIBRARY_PATH=
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/ipp/lib/intel64
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/compiler/lib/intel64_lin
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/mkl/lib/intel64_lin
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/tbb/lib/intel64/gcc4.7
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/daal/lib/intel64_lin
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/daal/../tbb/lib/intel64_lin/gcc4.4

prepend_path( "LD_LIBRARY_PATH" ,     pathJoin( gcc_base , "lib" ) )
prepend_path( "LD_LIBRARY_PATH" ,     pathJoin( gcc_base , "lib64" ) )

prepend_path( "LD_LIBRARY_PATH" ,        pathJoin( installDir , "compiler/lib/intel64_lin"            ) )
prepend_path( "LD_LIBRARY_PATH" ,        pathJoin( installDir , "ipp/lib/intel64"                     ) )
prepend_path( "LD_LIBRARY_PATH" ,        pathJoin( installDir , "mkl/lib/intel64_lin"                 ) )
prepend_path( "LD_LIBRARY_PATH" ,        pathJoin( installDir , "tbb/lib/intel64_lin/gcc4.7"          ) )
prepend_path( "LD_LIBRARY_PATH" ,        pathJoin( installDir , "daal/lib/intel64_lin"                ) )
prepend_path( "LD_LIBRARY_PATH" ,        pathJoin( base       , "debugger_2019/libipt/intel64/lib" ) )

--LD_LIBRARY_PATH=
-- /opt/apps/gcc/8.3.0/lib64
-- /opt/apps/gcc/8.3.0/lib
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/compiler/lib/intel64_lin
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/ipp/lib/intel64
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/mkl/lib/intel64_lin
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/tbb/lib/intel64/gcc4.7
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/daal/lib/intel64_lin
-- /opt/intel/debugger_2018/libipt/intel64/lib

prepend_path( "CPATH" ,     pathJoin( installDir , "ipp/include"  ) )
prepend_path( "CPATH" ,     pathJoin( installDir , "mkl/include"  ) )
prepend_path( "CPATH" ,     pathJoin( installDir , "tbb/include"  ) )
prepend_path( "CPATH" ,     pathJoin( installDir , "daal/include" ) )
prepend_path( "CPATH" ,     pathJoin( installDir , "pstl/include" ) )

--CPATH=
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/ipp/include
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/mkl/include
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/tbb/include
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/daal/include
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/pstl/include

prepend_path( "NLSPATH" ,     pathJoin( installDir , "compiler/lib/intel64/locale/%l_%t/%N"               ) )
prepend_path( "NLSPATH" ,     pathJoin( installDir , "mkl/lib/intel64_lin/locale/%l_%t/%N"                ) )
prepend_path( "NLSPATH" ,     pathJoin( base       , "debugger_2019/gdb/intel64/share/locale/%l_%t/%N" ) )

--NLSPATH=
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/compiler/lib/intel64/locale/%l_%t/%N
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/mkl/lib/intel64_lin/locale/%l_%t/%N
-- /opt/intel/debugger_2018/gdb/intel64/share/locale/%l_%t/%N

prepend_path( "PATH" ,        pathJoin( gcc_base   , "bin"         ) )
prepend_path( "PATH" ,        pathJoin( installDir , "bin/intel64" ) )

--PATH=
-- /opt/apps/gcc/8.3.0/bin
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/bin/intel64

setenv( "TBBROOT" ,           tbbRoot )

--TBBROOT=
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/tbb

setenv( "DAALROOT" ,          daalRoot )

--DAALROOT=
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/daal

setenv( "PSTLROOT" ,          pstlRoot )

--PSTLROOT=
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/pstl

setenv("PKG_CONFIG_PATH",     pathJoin(mklRoot, "bin/pkgconfig") )

--PKG_CONFIG_PATH=
-- /opt/intel/compilers_and_libraries_2019.4.243/linux/mkl/bin/pkgconfig

setenv( "PSXE_2019",            "1"                                              )
setenv( "ICC_BIN" ,             pathJoin(installDir , "bin" , arch               ) )
setenv( "IFC_BIN" ,             pathJoin(installDir , "bin" , arch               ) )
setenv( "ICC_LIB" ,             pathJoin(installDir , "compiler/lib" , arch      ) )
setenv( "IFC_LIB" ,             pathJoin(installDir , "compiler/lib" , arch      ) )
setenv( "TACC_INTEL_DIR" ,      installDir                                       )
setenv( "TACC_INTEL_BIN" ,      pathJoin(installDir , "bin/intel64"              ) )
setenv( "TACC_INTEL_LIB" ,      pathJoin(installDir , "compiler/lib/intel64"     ) )
setenv( "TACC_INTEL_INC" ,      pathJoin(installDir , "compiler/include/intel64" ) )

if (os.getenv("TACC_SYSTEM") == "frontera") then
  setenv( "TACC_VEC_FLAGS" ,      "-xCORE-AVX2 -axCORE-AVX512,MIC-AVX512" )
elseif (os.getenv("TACC_SYSTEM") == "stampede2") then
  setenv( "TACC_VEC_FLAGS" ,      "-xCORE-AVX2 -axCORE-AVX512,MIC-AVX512" )
elseif (os.getenv("TACC_SYSTEM") == "ls5") then
  setenv( "TACC_VEC_FLAGS" ,      "-xCORE-AVX-I -axCORE-AVX2" )
else
  setenv( "TACC_VEC_FLAGS" ,      "-xCORE-AVX2" )
end

prepend_path( "MODULEPATH" , "/opt/apps/intel19/modulefiles" )

family("compiler")

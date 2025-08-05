-- -*- lua -*-

help([[
        Intel Compilers
        This module loads Intel Compiler variables.
        { standard TACC variables: ICC_DIR,  ICC_BIN,  ICC_LIB  }
]])
------------------------------------------------------------------------
-- Intel Compilers support
------------------------------------------------------------------------

local version = "11.0"

prepend_path('PATH',            '/vol/local/intel/cc/cc/bin')
prepend_path('PATH',            '/vol/local/intel/fc/fc/bin')
prepend_path('PATH',            '/vol/local/intel/idb/idb/bin')
prepend_path('LD_LIBRARY_PATH', '/vol/local/intel/cc/cc/lib')
prepend_path('LD_LIBRARY_PATH', '/vol/local/intel/fc/fc/lib')
prepend_path('LD_LIBRARY_PATH', '/vol/local/intel/idb/idb/lib')
prepend_path('MANPATH',         '/vol/local/intel/cc/cc/man')
prepend_path('MANPATH',         '/vol/local/intel/fc/fc/man')
prepend_path('MANPATH',         '/vol/local/intel/idb/idb/man')

------------------------------------------------------------------------
-- Intel MKL support
------------------------------------------------------------------------

prepend_path('MANPATH',        '/vol/local/intel/mkl/mkl/man')
setenv(      'MKL_DIR',	       '/vol/local/intel/mkl/mkl/lib/lib')
setenv(      'MKL_INCLUDE',    '/vol/local/intel/mkl/mkl/include')
prepend_path('LD_LIBRARY_PATH','/vol/local/intel/mkl/mkl/lib/lib')

family("compiler")

pushenv( "CC", "icc")
pushenv( "CC", "icx")

pushenv( "RTM_CC", "icc")
pushenv( "RTM_CC", "icx")

local pkgVersion      = "10.1"
local pkgName         = "intel"
local pkgNameVer      = pathJoin(pkgName,pkgVersion)
local modulepath_root = os.getenv("MODULEPATH_ROOT")

prepend_path('MODULEPATH',     pathJoin(modulepath_root,"Compiler",pkgNameVer))


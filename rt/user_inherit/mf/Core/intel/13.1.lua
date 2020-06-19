local full_version = myModuleVersion()
local version      = full_version:gsub("%..*","")
local compiler     = myModuleName()
setenv("INTEL_KIND","SYSTEM")
whatis("Name: Intel Compiler")
whatis("Version: ".. full_version)
whatis("Category: compiler, runtime support")
whatis("Description: Intel Compiler Family (C/C++/Fortran for x86_64)")
whatis("URL: http://software.intel.com/en-us/articles/intel-compilers/")
prepend_path("PATH", "/unknown/apps/intel/13.1/bin/intel64")

prepend_path("MODULEPATH", pathJoin(os.getenv("MODULEPATH_ROOT"),"Compiler",compiler,version))

family("compiler")
help([[
The Intel module enables the Intel family of compilers (C/C++
and Fortran) and updates the $PATH, $LD_LIBRARY_PATH, and
$MANPATH environment variables to access the compiler binaries,
libraries, and available man pages, respectively.

The following additional environment variables are also defined:

$ICC_BIN                (path to icc/icpc compilers)
$ICC_LIB                (path to C/C++  libraries  )
$IFC_BIN                (path to ifort compiler    )
$IFC_LIB                (path to Fortran libraries )
$IIDB_BIN               (path to iidb debugger     )

See the man pages for icc, icpc, and ifort for detailed information
on available compiler options and command-line syntax

Version 13.1

]])

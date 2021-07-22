help(
[[
This module loads the Intel compiler suite.
]])

family("compilers")

-- Intel paths
whatis("(Website________) http://software.intel.com/en-us/intel-compilers")
local version = "14.0.0"
local base = "/software6/compilers/intel/composer_xe_2013_sp1"

setenv("CC",  pathJoin(base, "bin/icc"))
setenv("CXX", pathJoin(base, "bin/icpc"))
setenv("LD",  pathJoin(base, "bin/xild"))
setenv("AR",  pathJoin(base, "bin/xiar"))
setenv("F77", pathJoin(base, "bin/ifort"))
setenv("FC",  pathJoin(base, "bin/ifort"))

-- Licence on bishop
setenv("INTEL_LICENSE_FILE", "28519@10.225.3.12")

prepend_path("PATH",               pathJoin(base, "bin"))
prepend_path("MANPATH",            pathJoin(base, "man/en_US"))
prepend_path("LIBRARY_PATH",       pathJoin(base, "lib/intel64"))
prepend_path("LD_LIBRARY_PATH",    pathJoin(base, "lib/intel64"))

-- module path
local mroot = os.getenv("MODULEPATH_ROOT")
local mdir  = pathJoin(mroot,"Compilers","intel14.0")
prepend_path("MODULEPATH", mdir)

help(
[[
This module loads the Mvapich2 library.
]])

family("mpi")
whatis("(Website________) http://www.open-mpi.org/")

local base = "/software6/mpi/mvapich2/1.9_intel"

prepend_path("PATH",             pathJoin(base, "bin"))
--prepend_path("MANPATH",          pathJoin(base, "share/man"))  --no man page seems to get installed
prepend_path("LIBRARY_PATH",     pathJoin(base, "lib"))
prepend_path("LD_LIBRARY_PATH",  pathJoin(base, "lib"))
prepend_path("CPATH",     pathJoin(base, "include"))

local mroot = os.getenv("MODULEPATH_ROOT")
local mdir  = pathJoin(mroot,"MPI","intel14.0","mvapich2_1.9")
prepend_path("MODULEPATH",   mdir)


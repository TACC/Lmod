help(
[[
This module loads the OpenMPI library.
]])

family("mpi")
whatis("(Website________) http://www.open-mpi.org/")

local base = "/software6/mpi/openmpi/1.8.1_intel"

prepend_path("PATH",             pathJoin(base, "bin"))
prepend_path("MANPATH",          pathJoin(base, "share/man"))
prepend_path("LIBRARY_PATH",     pathJoin(base, "lib"))
prepend_path("LD_LIBRARY_PATH",  pathJoin(base, "lib"))
prepend_path("CPATH",     pathJoin(base, "include"))

setenv("OMPI_MCA_plm_rsh_num_concurrent", 960)

local mroot = os.getenv("MODULEPATH_ROOT")
local mdir  = pathJoin(mroot,"MPI","intel14.0","openmpi1.8.1")
prepend_path("MODULEPATH",   mdir)


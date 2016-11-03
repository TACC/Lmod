-- -*- lua -*-
local compiler_dir = "intel/10.1"
local mpi_dir      = "openmpi/1.2.6"
local mdir         = pathJoin(os.getenv('MODULEPATH_ROOT'), "MPI",compiler_dir,mpi_dir)

local pkgRoot      = "/vol/local/mpi"
local pkg          = "openmpi/1.2.6.opt"
local mpihome      = pathJoin(pkgRoot, compiler_dir, pkg)

prepend_path('MODULEPATH',      mdir)
prepend_path('PATH',            pathJoin(mpihome,"bin"))
prepend_path('LD_LIBRARY_PATH', pathJoin(mpihome,"lib"))
prepend_path('MANPATH',         pathJoin(mpihome,"man"))
setenv(      'MPIHOME',         mpihome)
family("MPI")

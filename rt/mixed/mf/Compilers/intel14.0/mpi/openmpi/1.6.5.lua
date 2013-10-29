family("MPI")
local mroot = os.getenv("MODULEPATH_ROOT")
local mdir  = pathJoin(mroot,"MPI","intel14.0","openmpi1.6")
append_path("MODULEPATH", mdir)

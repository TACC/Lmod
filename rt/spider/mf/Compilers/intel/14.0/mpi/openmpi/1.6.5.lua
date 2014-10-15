local mroot = os.getenv("TEST_MROOT")
local mpath = pathJoin(mroot, "MPI/openmpi/1.6/Compilers/intel/14.0/")
prepend_path("MODULEPATH", mpath)

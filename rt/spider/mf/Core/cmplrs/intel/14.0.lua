local mroot = os.getenv("TEST_MROOT")
local mpath = pathJoin(mroot, "Compilers/intel/14.0")
prepend_path("MODULEPATH", mpath)

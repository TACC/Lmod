setenv("INTEL","13.1.3")
local mdir = pathJoin(os.getenv("MODULEPATH_ROOT"),"Compiler/intel/13.1")
prepend_path("MODULEPATH",mdir)
family("Compiler")

setenv("GCC",myModuleVersion())
local mdir = pathJoin(os.getenv("MODULEPATH_ROOT"),"Compiler/intel/18.0")
prepend_path("MODULEPATH",mdir)
family("Compiler")

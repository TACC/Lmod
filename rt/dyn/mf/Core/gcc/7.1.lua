setenv("GCC",myModuleVersion())
local mdir = pathJoin(os.getenv("MODULEPATH_ROOT"),"Compiler/gcc/7.1")
prepend_path("MODULEPATH",mdir)
family("Compiler")

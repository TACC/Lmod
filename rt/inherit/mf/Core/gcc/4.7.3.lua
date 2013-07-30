setenv("GCC","4.7.3")
local mdir = pathJoin(os.getenv("MODULEPATH_ROOT"),"Compiler/gcc/4.7")
prepend_path("MODULEPATH",mdir)
family("Compiler")


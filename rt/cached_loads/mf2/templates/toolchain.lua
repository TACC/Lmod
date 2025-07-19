-- -*- lua -*-
-- category: prgenvs
family("prgenvs")
-- Add compilers module path
append_path("MODULEPATH", pathJoin(os.getenv("MODULEPATH_ROOT"), "compilers"))
-- load the appropriate compiler for this toolchain
load(myModuleVersion())

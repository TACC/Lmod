depends_on("GCCcore/11.0")

local MODULEPATH_ROOT = myFileName():match('(.*)/Core/.*')
prepend_path("MODULEPATH",pathJoin(MODULEPATH_ROOT,"Compiler/gcc/11"))




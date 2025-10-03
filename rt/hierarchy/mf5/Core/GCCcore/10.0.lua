local MODULEPATH_ROOT = myFileName():match('(.*)/Core/.*')
prepend_path("MODULEPATH",pathJoin(MODULEPATH_ROOT,"Compiler/GCCcore/10"))


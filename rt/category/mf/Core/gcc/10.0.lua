local MODULEPATH_ROOT = myFileName():match('(.*)/Core/gcc/.*')
prepend_path("MODULEPATH",pathJoin(MODULEPATH_ROOT,"Compiler/gcc/10"))
whatis("Category: App,IO")

local MODULEPATH_ROOT = myFileName():match('(.*)/Compiler/.*')
prepend_path("MODULEPATH",pathJoin(MODULEPATH_ROOT,"MPI/gcc/10/mpich/10"))
whatis("Category: MPI")

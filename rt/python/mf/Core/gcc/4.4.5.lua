local root = os.getenv("MODULEPATH_ROOT")
prepend_path("MODULEPATH", pathJoin(root, "mf/Compiler/gcc/4.4"))
family("compiler")

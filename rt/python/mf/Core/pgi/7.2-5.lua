local root = os.getenv("MODULEPATH_ROOT")
prepend_path("MODULEPATH", pathJoin(root, "mf/Compiler/pgi/7.2-5"))
family("compiler")

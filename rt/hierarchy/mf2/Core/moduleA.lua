local mroot = os.getenv("MODULEPATH_ROOT") or ""
prepend_path("MODULEPATH", pathJoin(mroot,"Compiler"))

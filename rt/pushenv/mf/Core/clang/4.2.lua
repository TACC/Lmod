pushenv("CC","icc")
prepend_path('MODULEPATH',     pathJoin(os.getenv("MODULEPATH_ROOT"),mdir))

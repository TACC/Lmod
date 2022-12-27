local yales2_home = "/unknown/a/b/c"
setenv("Y2_PYTHON_VERSION", os.getenv("EBVERSIONPYTHON"))
prepend_path("MODULEPATH", pathJoin(yales2_home, "modules"))

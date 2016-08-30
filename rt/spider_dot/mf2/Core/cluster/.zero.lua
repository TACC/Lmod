local mroot = os.getenv("MODULEPATH_ROOT2")
setenv("CLUSTER_NAME","zero")
prepend_path("MODULEPATH",pathJoin(mroot,"Zero"))

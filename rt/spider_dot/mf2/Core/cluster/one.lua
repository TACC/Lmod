local mroot = os.getenv("MODULEPATH_ROOT2")
setenv("CLUSTER_NAME","one")
prepend_path("MODULEPATH",pathJoin(mroot,"One"))

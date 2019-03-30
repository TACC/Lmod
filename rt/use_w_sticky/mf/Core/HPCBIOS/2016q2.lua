local mp_root = os.getenv("MODULEPATH_ROOT")
append_path("MODULEPATH",pathJoin(mp_root,"Other"))
add_property("lmod","sticky")

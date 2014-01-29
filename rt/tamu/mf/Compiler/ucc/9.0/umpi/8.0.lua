family("MPI")
prereq("atleast("ucc","9.0")")
local mroot=os.getenv("MODULEPATH_ROOT")
prepend_path("MODULEPATH",pathJoin(mroot,"MPI/ucc/9.0/umpi/8.0"))
LmodMessage("Module umpi/8.0 loaded")


local mroot = os.getenv("MODULEPATH_ROOT")
family("Compiler")
local mpath = pathJoin(mroot,"Compiler/ucc/9.0")
prepend_path("MODULEPATH",pathJoin(mroot,"Compiler/ucc/9.0"))
LmodMessage("Module ucc/9.0 loaded")


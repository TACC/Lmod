help([[Configures IBM XL Compiler environment
Depends on: common
Dependents: Libraries built with this compiler
Family: compiler
]])
 
 
family("compiler")

load("compiler-common/.ibm")

local IBM_VER = "13"

local mroot = os.getenv("MODULEPATH_ROOT")
local mdir = pathJoin(mroot, "Compiler/ibm", IBM_VER)
append_path("MODULEPATH", mdir)

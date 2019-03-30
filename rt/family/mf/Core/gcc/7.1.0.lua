help([[Sets up gcc environment. 
Depends on: common
Dependents: Libraries built with this compiler
Family: compiler
]])

family("compiler")

load("compiler-common/.gcc")

local GCC_PATH="/apps/gcc/7.1.0/ppc64le"
local GCC_VER="7"

local mroot = os.getenv("MODULEPATH_ROOT")
local mdir = pathJoin(mroot, "Compiler/gcc", GCC_VER)
prepend_path("MODULEPATH", mdir)



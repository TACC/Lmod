prereq(atleast("ucc","1.0"))
local mroot=os.getenv("MODULEPATH_ROOT")
prepend_path("MODULEPATH",pathJoin(mroot,"MPI/ucc/1.0",myModuleFullName()))
LmodMessage("Module "..myModuleName().."/"..myModuleVersion().." loaded")

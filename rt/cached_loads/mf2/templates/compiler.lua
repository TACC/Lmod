-- -*- lua -*-
-- category: compilers
local name = myModuleName()
local version = myModuleVersion()

if (isloaded(pathJoin("toolchain",name)) or mode() ~= "load") then
    append_path("MODULEPATH",pathJoin(os.getenv("MODULEPATH_ROOT"),  "flavours", name, version))
end
prepend_path("PATH",pathJoin("/apps",name,version,"bin"))

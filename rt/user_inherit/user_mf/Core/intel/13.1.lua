inherit()
local compiler = myModuleName()
local MP_ROOT  = os.getenv("MY_MODULEPATH_ROOT")
local version  = myModuleVersion():gsub("%..*","") -- extract first number 9.1 -> 9

prepend_path("MODULEPATH", pathJoin(MP_ROOT, "Compiler",compiler,version))

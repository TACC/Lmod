local fullVersion  = myModuleVersion()
local version      = fullVersion:gsub("%..*","")
local pkgName      = myModuleName()
local hierA        = hierarchyA(pathJoin(pkgName,fullVersion),1)
local compilerV    = hierA[1]
local compilerD    = compilerV:gsub("/","-"):gsub("%.","_")
local base         = pathJoin("/opt/apps",compilerD,pkgName,fullVersion)

prepend_path("PATH",       pathJoin(base,"bin"))
prepend_path("MODULEPATH", pathJoin(os.getenv("MY_MODULEPATH_ROOT"),"Compiler",compilerV,pkgName,version))

family("compiler")
whatis("Version: ".. fullVersion)

local pkgVersion = "9"
local pkgName    = myModuleName()
local mroot = os.getenv("MODULEPATH_ROOT")
local cmplr = pathJoin("Compiler",pkgName,pkgVersion)
prepend_path("MODULEPATH",pathJoin(mroot,cmplr))

local hroot   = pathJoin(os.getenv("HOME") or "","myModules")
local userDir = pathJoin(hroot,cmplr)
if (isDir(userDir)) then
   prepend_path("MODULEPATH",userDir)
end

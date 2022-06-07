local pkgVersion = "9"
local pkgName    = myModuleName()
local cmplr      = pathJoin("Compiler",pkgName,pkgVersion)
local hroot      = pathJoin(os.getenv("HOME") or "","myModules")
local userDir    = pathJoin(hroot,cmplr)

haveDynamicMPATH()

if (isDir(userDir)) then
   prepend_path("MODULEPATH",userDir)
end
   

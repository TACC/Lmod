local pkgVersion = "4"
local pkgName    = myModuleName()
local TEST_root = myFileName():match( '(.*)/Core/tcc/.*' )
local userDir   = pathJoin(TEST_root,"Compiler",pkgName, pkgVersion)

if (isDir(userDir)) then
   prepend_path("MODULEPATH",userDir)
end


local mroot = myFileName():match('(.*)/Core/gcc')
prepend_path("MODULEPATH", pathJoin(mroot, "Compiler/gcc10"))
local hroot   = pathJoin(os.getenv("HOME") or "","myModules4")
local userDir = pathJoin(hroot,"Compiler/gcc10")
if (isDir(userDir)) then
   prepend_path("MODULEPATH",userDir)
end

family("compiler")

local hroot   = pathJoin(os.getenv("HOME") or "","myModules2")
local userDir = pathJoin(hroot,"Core")
if (isDir(userDir)) then
   prepend_path("MODULEPATH",userDir)
end
haveDynamicMPATH()

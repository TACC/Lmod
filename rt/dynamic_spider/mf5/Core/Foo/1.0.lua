local hroot   = os.getenv("MODULEPATH_ROOT")
local userDir = pathJoin(hroot, os.getenv("STEPH") or "")
if (isDir(userDir)) then
   prepend_path("MODULEPATH",userDir)
end
haveDynamicMPATH()

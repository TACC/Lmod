local base = pathJoin("/opt", myModuleFullName())
prepend_path("PATH", pathJoin(base, "bin"))
if (mode() == "load") then
   LmodMessage("[+] Loading " .. myModuleName() .. ", version " .. myModuleVersion() .. "...")
end
if (mode() == "unload") then
   LmodMessage("[-] Unloading " .. myModuleName() .. ", version " .. myModuleVersion() .. "...")
end

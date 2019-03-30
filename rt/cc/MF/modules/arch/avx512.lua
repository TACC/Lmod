if (mode() ~= "spider") then
   local mroot = os.getenv("MODULEPATH_ROOT")
   prepend_path("MODULEPATH",  pathJoin(mroot, "modules-avx512"))
end

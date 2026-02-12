-- Module modA: Modifies MODULEPATH to add NewPath
local mroot = os.getenv("MODULEPATH_ROOT")
if (mode() == "load") then
   prepend_path("MODULEPATH", pathJoin(mroot, "NewPath"))
end





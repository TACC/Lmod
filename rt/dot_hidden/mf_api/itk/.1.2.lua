-- IS849 Wave 1: dot-hidden version for myModuleFullNameAndAlias()
whatis("itk dot-hidden version for IS849 API test")
local aliasFullName, trueFullName = myModuleFullNameAndAlias()
setenv("IS849_ALIAS_FULL", aliasFullName)
setenv("IS849_TRUE_FULL", trueFullName)
if (mode() == "unload") then
   LmodMessage("IS849 unload alias=" .. aliasFullName .. " true=" .. trueFullName)
end

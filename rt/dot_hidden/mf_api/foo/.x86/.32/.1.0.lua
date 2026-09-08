-- IS849 Wave 1: explicit dotted NVV (no undotted sibling)
whatis("foo dotted NVV for IS849 API test")
local aliasFullName, trueFullName = myModuleFullNameAndAlias()
setenv("IS849_ALIAS_FULL", aliasFullName)
setenv("IS849_TRUE_FULL", trueFullName)
if (mode() == "unload") then
   LmodMessage("IS849 unload alias=" .. aliasFullName .. " true=" .. trueFullName)
end

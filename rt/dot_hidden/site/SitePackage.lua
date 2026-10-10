local orig_myModuleFullName = myModuleFullName
local orig_myModuleVersion  = myModuleVersion

local function myModuleFullName()
   local aliasFullName, trueFullName = myModuleFullNameAndAlias()
   if (aliasFullName == trueFullName) then
      return orig_myModuleFullName()
   end
   return aliasFullName
end

local function myModuleVersion()
   local full = myModuleFullName()
   local sn   = myModuleName()
   return extractVersion(full, sn) or ""
end

sandbox_registration{
   myModuleFullName = myModuleFullName,
   myModuleVersion  = myModuleVersion,
}

local oldD   = math.min(2021,tonumber(os.date("%Y")))
local cutoff = string.format("%da", oldD - 2)
LmodWarning{msg="sisc_deprecated_module", fullName=myModuleFullName(), tcver_cutoff=cutoff}

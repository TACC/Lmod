-- Set new stage variables
local stage = myModuleVersion()
local stageroot = pathJoin(os.getenv("MROOT2"), "Stages")
local pkgroot = pathJoin(stageroot, stage)

whatis([[  Module to set up the environment for requested stage ( ]] .. stage .. [[ )]])

-- Let's tidy things up a little and remove everything Stage/UI related
local old_modulepath = os.getenv("MODULEPATH")
-- Sanitize old_modulepath
if old_modulepath == nil then
    old_modulepath = ""
end
for i in string.gmatch(old_modulepath, "([^:]+)") do
    if (i:find("/Stages/") or i:find("/UI/Compilers")) then
        remove_path("MODULEPATH", i)
    end
end

-- Give access to new stage
prepend_path("MODULEPATH", pathJoin(pkgroot, "UI/Compilers"))

-- Make the module 'sticky' so it is hard to unload
add_property("lmod", "sticky")

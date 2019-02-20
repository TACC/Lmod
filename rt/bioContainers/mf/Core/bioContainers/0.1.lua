whatis("Name: biocontainers")
whatis("Version: 0.1.0")
whatis("Category: Biology")
whatis("Keywords: bio, containers, biocontainer, bioconda, singularity")
whatis("Description: Biocontainers accessible through module files")
whatis("URL: https://biocontainers.pro/")

local bcd = pathJoin(os.getenv("testDir"),"bcd")

setenv("BIOCONTAINER_DIR",      bcd)
setenv("LMOD_CACHED_LOADS",     "yes")
prepend_path("LMOD_RC",         bcd .. "/lmod/lmodrc.lua")
if(mode() ~= "spider") then
  prepend_path("MODULEPATH",    bcd .. "/mf")
end

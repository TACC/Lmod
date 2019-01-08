local cc_cluster = os.getenv("CC_CLUSTER") or "computecanada"
local arch = "avx512"
local interconnect = os.getenv("RSNT_INTERCONNECT") or ""

if not interconnect or interconnect == "" then
	if cc_cluster == "cedar" then
		interconnect = "omnipath"
	else
		interconnect = "infiniband"
	end
end
local generic_nixpkgs = false

local mroot = os.getenv("MODULEPATH_ROOT")
assert(loadfile(pathJoin(mroot,"modules/nixpkgs/16.09.lua.core")))(arch, interconnect, generic_nixpkgs)

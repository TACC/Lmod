local cc_cluster = os.getenv("CC_CLUSTER") or "computecanada"
local arch = os.getenv("RSNT_ARCH") or ""
local interconnect = os.getenv("RSNT_INTERCONNECT") or ""

if not arch or arch == "" then
	if cc_cluster == "cedar" or cc_cluster == "graham" or cc_cluster == "computecanada" then
		arch = "avx2"
	elseif cc_cluster == "beluga" then
		arch = "avx512"
	end
end
if not interconnect or interconnect == "" then
	if cc_cluster == "cedar" then
		interconnect = "omnipath"
	else
		interconnect = "infiniband"
	end
end
local generic_nixpkgs = true
local mroot = os.getenv("MODULEPATH_ROOT")

assert(loadfile(pathJoin(mroot,"modules/nixpkgs/16.09.lua.core")))(arch, interconnect, generic_nixpkgs)

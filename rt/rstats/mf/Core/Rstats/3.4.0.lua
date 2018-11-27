--
-- Create environment variables.
--
local r_bin   = "/opt/apps/intel17/impi17_0/Rstats/3.4.0/bin"
prepend_path("PATH", r_bin)
if (not isloaded("Rpkgs/3.4.0")) then
   try_load("Rpkgs/3.4.0")
end

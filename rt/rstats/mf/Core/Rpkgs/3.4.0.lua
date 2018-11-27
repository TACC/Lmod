--
-- Create environment variables.
--

if (not isloaded("Rstats/3.4.0")) then
   load("Rstats/3.4.0")
end


local snow_bin = "/opt/apps/intel17/impi17_0/RstatsPackages/3.4.0/packages/snow/"

prepend_path("PATH", snow_bin)

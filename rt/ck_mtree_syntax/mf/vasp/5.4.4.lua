local help_message=[[
The TACC VASP module appends the path to the vasp executables
to the PATH environment variable.  Also TACC_VASP_DIR, and
TACC_VASP_BIN are set to VASP home and bin directories.

Users have to show their licenses and be confirmed by
VASP team that they are registered users under that licenses
Scan a copy of the license with the license number and send to hliu@tacc.utexas.edu

The VASP executables are
vasp_std: compiled with pre processing flag: -DNGZhalf
vasp_gam: compiled with pre processing flag: -DNGZhalf -DwNGZhalf
vasp_ncl: compiled without above pre processing flags
vasp_std_vtst: vasp_std with VTST
vasp_gam_vtst: vasp_gam with VTST
vasp_ncl_vtst: vasp_ncl with VTST
vtstscripts-947/: utility scripts of VTST
bee: BEEF analysis code

This the VASP.5.4.4 release.

Version 5.4.4
]]


whatis("Version: 5.4.4")
whatis("Category: application, chemistry")
whatis("Keywords: Chemistry, Density Functional Theory, Molecular Dynamics")
whatis("URL:https://www.vasp.at/")
whatis("Description: Vienna Ab-Initio Simulation Package")
help(help_message,"\n")


local group = "G-802400"
local found = true


local err_message = [[
You do not have access to VASP.5.4.4!


Users have to show their licenses and be confirmed by the
VASP team that they are registered users under that license.
Scan a copy of the license with the license number and send to hliu@tacc.utexas.edu
]]


if (found) then
local vasp_dir="/home1/apps/intel19/impi19_0/vasp/5.4.4"

prepend_path(    "PATH",                pathJoin(vasp_dir, "bin"))
setenv( "TACC_VASP_DIR",                vasp_dir)
setenv( "TACC_VASP_BIN",       pathJoin(vasp_dir, "bin"))

else
  LmodError(err_message,"\n")
end

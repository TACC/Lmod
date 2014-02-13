
local help_message = [[
The TACC VASP module appends the path to the vasp executables
to the PATH environment variable.  Also TACC_VASP_DIR, and
TACC_VASP_BIN are set to VASP home and bin directories.

Users have to show their licenses and be confirmed by
VASP team that they are registered users under that licenses
Scan a copy the license and send to hliu@tacc.utexas.edu

The VASP executables are
vasp_std: compiled with pre processing flag: -DNGZhalf
vasp_gamma: compiled with pre processing flag: -DNGZhalf -DwNGZhalf
vasp_ncl: compiled without above pre processing flags
vasp_std_vtst: vasp_std with TST
vasp_gamma_vtst: vasp_gamma with TST
vasp_ncl_vtst: vasp_ncl with TST
vtstscripts/: utility scripts of TST


Version 5.2
]]


local err_message = [[
You do not access to VASP.5.2!


Users have to show their licenses and be confirmed by
VASP team that they are registered users under that licenses
Scan a copy the license and send to hliu@tacc.utexas.edu
]]

local group = "#$%$#@@!"
local grps  = capture("groups")
local found = false
for g in grps:split("[ \n]") do
   if (g == group)  then
      found = true
      break
   end
end

whatis("Name: VASP")
whatis("Version: 5.2")
whatis("Category: application, chemistry")
whatis("URL:http://cms.mpi.univie.ac.at/vasp/")
whatis("Description: Vienna Ab-Initio Simulation Package")

help(help_message)

if (found) then
   setenv("TACC_VASP_DIR","/opt/apps/intel10_1/mvapich1_1_0_1/vasp/5.2")
   setenv("TACC_VASP_BIN","/opt/apps/intel10_1/mvapich1_1_0_1/vasp/5.2/bin")
   append_path("PATH","/opt/apps/intel10_1/mvapich1_1_0_1/vasp/5.2/bin")

else
   LmodError(err_message,"\n")
end


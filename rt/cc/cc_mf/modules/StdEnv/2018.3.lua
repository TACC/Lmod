--add_property(   "lmod", "sticky")

local root = "/cvmfs/soft.computecanada.ca/nix/var/nix/profiles/16.09"

require("os")
load("nixpkgs/16.09")
load("imkl/2018.3.222")
load("intel/2018.3")
load("openmpi/3.1.2")

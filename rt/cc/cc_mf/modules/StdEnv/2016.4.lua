--add_property(   "lmod", "sticky")

local root = "/cvmfs/soft.computecanada.ca/nix/var/nix/profiles/16.09"

require("os")
load("nixpkgs/16.09")
load("imkl/11.3.4.258")
load("intel/2016.4")
load("openmpi/2.1.1")

if (userInGroup("G-XYZ")) then
   prepend_path("PATH", "/opt/apps/acme_xyz/1.2.3/bin")
   -- ...
else
   color_banner("red")
   LmodMessage("You do not have access to ACME XYZ.  Please see ...")
   color_banner("red")
   os.exit(1)
end

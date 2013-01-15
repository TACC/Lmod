-- This is a placeholder for site specific functions.

--------------------------------------------------------------------------------
-- Anything in this file will automatically be loaded everytime the Lmod command
-- is run.  It is probably best that you not modify this file however.

-- A better approach is to create a file named "SitePackage.lua" in a different
-- directory separate from the Lmod installed directory.  Then you should modify
-- your modules.sh and modules.csh (or however you initialize the "module" command) 
-- with:

--    (for bash, zsh, etc)
--    export LMOD_PACKAGE_PATH=/path/to/the/Site/Directory

--    (for csh)
--    setenv LMOD_PACKAGE_PATH /path/to/the/Site/Directory

-- A "SitePackage.lua" in that directory will override the one in the Lmod
-- install directory.




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

-----------------------------------------------------------------------------
--  Any function here that is called by a module file must be registered with
--  the sandbox.  For example you have functions:

--      function sam()
--      end

--      function bill()
--      end

--  Then you have to do the following

--      sandbox_registration{ sam = sam, bill = bill}

-- DO NOT FORGET TO USE CURLY BRACES "{}" and NOT PARENS "()"!!!!

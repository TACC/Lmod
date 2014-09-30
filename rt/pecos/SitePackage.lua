require("strict")
require("string_util")
local dbg        = require("Dbg"):dbg()
local SYSTEM_DIR = os.getenv("SYSTEM_DIR")
local MROOT      = os.getenv("MODULEPATH_ROOT")

-- Add all applicable derived modulepaths when loading
-- newmodname/newmodversion
-- Or remove all applicable derived modulepaths when unloading
function edit_derived_modulepaths(derived_mod_dir, newmodname, newmodversion)
   dbg.start{"edit_derived_modulepaths(",derived_mod_dir, ",", newmodname,
             ",",newmodversion,")"}

   -- Escape special characters so that the module name and module
   -- version can be used in Lua patterns
   local escmodname    = newmodname:escape()
   local escmodversion = newmodversion:escape()
   local newFullName   = pathJoin(newmodname, newmodversion)
   local myMode        = mode()

   -- Find every parent directory for this module version
   local outer_find = capture( "find "..derived_mod_dir.." -type d -name "..newmodversion )
   for newmoddir in outer_find:gmatch("[^\n]+") do

      -- Make sure this is *our* module's directory
      if newmoddir:find(escmodname.."/"..escmodversion.."$") then

         -- Find every descendant directory with module files
         local inner_find = capture( "find "..newmoddir.." -type d -name modulefiles" )
         for modfilesdir in inner_find:gmatch("[^\n]+") do

            dbg.print{"modfilesdir: ",modfilesdir,"\n"}
            -- Load module files directories that we have all
            -- prerequisites for
            if (myMode == "load" or myMode == "spider") then
               local _, _, systemType, modlist =
                  modfilesdir:find( MROOT .. "/([^/]+)/(.+)/modulefiles")
               if (systemType == SYSTEM_DIR) then
                  -- Each directory name pair is a prerequisite module
                  local have_all_modules = true
                  if (myMode == "load") then
                     for modname, modversion in modlist:gmatch("([^/]+)/([^/]+)") do
                        local fullName = pathJoin(modname, modversion)
                        local mt       = MT:mt()
                        local status   = mt:getStatus(fullName)
                        dbg.print{"module: ",fullName, " status: ", status,"\n"}
                        if (( fullName ~= newFullName) and
                            not (isloaded(fullName) or isPending(fullName))) then
                           have_all_modules = false
                           break
                        end
                     end
                  end
                  -- We have all prerequisites, so load the new path.
                  if (have_all_modules) then
                     prepend_path( "MODULEPATH", modfilesdir )
                  end
               end
            elseif (mode() == "unload") then
               -- mode unload turns prepend into remove
               prepend_path( "MODULEPATH", modfilesdir )
            end
         end
      end
   end
   dbg.fini("edit_derived_modulepaths")
end


-- Add all applicable derived modulepaths when loading
-- a new derived_mod_dir
function edit_new_derived_modulepaths(derived_mod_dir)
   dbg.start{"edit_new_derived_modulepaths(",derived_mod_dir,")"}

   -- Find every parent directory for this module version
   local inner_find = capture( "find "..derived_mod_dir.." -type d -name modulefiles" )

   for modfilesdir in inner_find:gmatch("[^\n]+") do

      -- Load module files directories that we have all
      -- prerequisites for
      if (mode() == "load" or mode() == "spider") then
         -- Each directory name pair is a prerequisite module
         local have_all_modules = true
         for modname, modversion in modlist:gmatch("([^/]+)/([^/]+)") do
            if (not isloaded(modname.."/"..modversion)) then
               have_all_modules = false
               break
            end
         end

         -- We have all prerequisites, so load the new path.
         if (have_all_modules) then
            prepend_path( "MODULEPATH", modfilesdir )
         end
      elseif (mode() == "unload") then
         -- mode unload turns prepend into remove
         prepend_path( "MODULEPATH", modfilesdir )
      end
   end
   dbg.fini("edit_new_derived_modulepaths")
end

sandbox_registration { edit_derived_modulepaths     = edit_derived_modulepaths,
                       edit_new_derived_modulepaths = edit_new_derived_modulepaths, }

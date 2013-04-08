require("strict")
require("escape")
local Dbg        = require("Dbg")
local SYSTEM_DIR = os.getenv("SYSTEM_DIR")
local MROOT      = os.getenv("MODULEPATH_ROOT")

-- Add all applicable derived modulepaths when loading
-- newmodname/newmodversion
-- Or remove all applicable derived modulepaths when unloading
function edit_derived_modulepaths(derived_mod_dir, newmodname, newmodversion)
   local dbg = Dbg:dbg()
   dbg.start("edit_derived_modulepaths(",derived_mod_dir, ",", newmodname,
             ",",newmodversion,")")

   -- Escape special characters so that the module name and module
   -- version can be used in Lua patterns
   local escmodname    = escape(newmodname)
   local escmodversion = escape(newmodversion)
   local newFullName   = pathJoin(newmodname, newmodversion)

   -- Find every parent directory for this module version
   local outer_find = capture( "find "..derived_mod_dir.." -type d -name "..newmodversion )
   for newmoddir in string.gmatch(outer_find, "[^\n]+") do
      
      -- Make sure this is *our* module's directory
      if string.find(newmoddir, escmodname.."/"..escmodversion.."$") then
     
         -- Find every descendant directory with module files
         local inner_find = capture( "find "..newmoddir.." -type d -name modulefiles" )
         for modfilesdir in string.gmatch(inner_find, "[^\n]+") do

            dbg.print("modfilesdir: ",modfilesdir,"\n")
            -- Load module files directories that we have all
            -- prerequisites for
            if (mode() == "load" or mode() == "spider") then
               local _, _, systemType, modlist =
                  modfilesdir:find( MROOT .. "/([^/]+)/(.+)/modulefiles")
               if (systemType == SYSTEM_DIR) then
                  -- Each directory name pair is a prerequisite module
                  local have_all_modules = true
                  for modname, modversion in string.gfind(modlist, "([^/]+)/([^/]+)") do
                     local fullName = pathJoin(modname, modversion)
                     local mt       = MT:mt()
                     local status   = mt:getStatus(fullName)
                     dbg.print("module: ",fullName, " status: ", status,"\n")
                     if (( fullName ~= newFullName) and
                         not (isloaded(fullName) or isPending(fullName))) then
                        have_all_modules = false
                        break
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
   dbg.fini()
end


-- Add all applicable derived modulepaths when loading
-- a new derived_mod_dir
function edit_new_derived_modulepaths(derived_mod_dir)

   -- Find every parent directory for this module version
   local inner_find = capture( "find "..derived_mod_dir.." -type d -name modulefiles" )
  
   for modfilesdir in string.gmatch(inner_find, "[^\n]+") do

      -- Load module files directories that we have all
      -- prerequisites for
      if (mode() == "load" or mode() == "spider") then
         -- Each directory name pair is a prerequisite module
         local have_all_modules = true
         for modname, modversion in string.gfind(modlist, "([^/]+)/([^/]+)") do
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
end

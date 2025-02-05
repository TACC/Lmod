local hook    = require("Hook")
local function load_hook(t)
      -- the arg t is a table:
      --     t.modFullName:  the module full name: (i.e: gcc/4.7.2)
      --     t.fn:           The file name: (i.e /apps/modulefiles/Core/gcc/4.7.2.lua)
      --     t.mname:        The Module Name object. 

   local isVisible = t.mname:isVisible()
   io.stderr:write("module: ",t.modFullName," isVisible status: ",tostring(isVisible),"\n")
end
hook.register("load", load_hook)

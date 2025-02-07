local hook = require("Hook")

local function xcc_depend_hook(t)
      -- the arg t is a table:
      --     t.modFullName:  the module full name: (i.e: gcc/4.7.2)
      --     t.fn:           The file name: (i.e /apps/modulefiles/Core/gcc/4.7.2.lua)
      --     t.mname:        The Module Name object. 

   if (t.modFullName:find("xcc")) then
      depends_on("d")
   end
end

hook.register("load",   xcc_depend_hook)
hook.register("unload", xcc_depend_hook)


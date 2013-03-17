require("strict")
local hook   = require("Hook")

-- By using the hook.register function, this function "load_hook" is called
-- ever time a module is loaded with the file name and the module name.


function load_hook(t)
   -- the arg t is a table:
   --     t.modFullname:  the module full name: (i.e: gcc/4.7.2)
   --     t.fn:           The file name: (i.e /apps/modulefiles/Core/gcc/4.7.2.lua)

   -- Your site can use this any way that suits.  Here are some possibilities:
   --  a) Write this information into a file in your users directory (say ~/.lmod.d/.save).
   --     Then once a month collect this data.
   --  b) have this function call syslogd to register that this module was loaded by this
   --     user
   --  c) Write the same information directly to some database.


end




hook.register("load",load_hook)



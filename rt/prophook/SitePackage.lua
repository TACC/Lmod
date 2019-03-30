require("strict")
local Dbg     = require("Dbg"):dbg()
local hook    = require("Hook")

local function set_props(t)
   ------------------------------------------------------------
   -- table of properties for fullnames or sn

   local propT = {
      ["bowtie/1.2.3"] = { {name = "type_", value = "bioinfomatics"},
                           {name = "state", value = "testing"}, },
      ["bowtie"]       = { {name = "type_", value = "bioinfomatics"}, },
      ["gcc"]          = { {name = "type_", value = "tools"}, },
   }

   ------------------------------------------------------------
   -- Look for fullName first otherwise sn

   local a = propT[myModuleFullName()] or  propT[myModuleName()]

   if (a) then
      ----------------------------------------------------------
      -- Loop over a array and fill properties for this module.
      for i = 1,#a do
         local entry = a[i]
         add_property(entry.name, entry.value)
      end
   end
end

hook.register("load",        set_props)
hook.register("load_spider", set_props)

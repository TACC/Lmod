-- -*- lua -*-
require("strict")

MC_ComputeHash         = inheritsFrom(MasterControl)
MC_ComputeHash.my_name = "MC_ComputeHash"
local M                = MC_ComputeHash
local Dbg              = require("Dbg")
local concatTbl        = table.concat
local A                = ComputeModuleResultsA

function ShowCmd(name, ...)
   local a = {}
   for _,v in ipairs{...} do
      local s = tostring(v)
      if (type(v) ~= "boolean") then
         s = "\"".. s .."\""
      end
      a[#a + 1] = s
   end
   local b = {}
   b[#b+1] = name
   b[#b+1] = "("
   b[#b+1] = concatTbl(a,",")
   b[#b+1] = ")\n"
   A[#A+1] = concatTbl(b,"")
end

M.help            = MasterControl.quiet
M.whatis          = MasterControl.quiet
M.setenv          = MasterControl.quiet
M.unsetenv        = MasterControl.quiet
M.inherit         = MasterControl.quiet
M.set_alias       = MasterControl.quiet
M.unset_alias     = MasterControl.quiet
M.display         = MasterControl.quiet
M.add_property    = MasterControl.quiet
M.remove_property = MasterControl.quiet


function M.always_load(self, ...)
   ShowCmd("always_load",...)
end

function M.always_unload(self, ...)
   ShowCmd("always_load",...)
end

function M.prepend_path(self, name, value, sep)
   if (name ~= "MODULEPATH") then return end
   ShowCmd("prepend_path", name, value, sep)
end

function M.append_path(self, name, value, sep)
   if (name ~= "MODULEPATH") then return end
   ShowCmd("append_path", name, value, sep)
end

function M.remove_path(self, name, value, sep)
   if (name ~= "MODULEPATH") then return end
   ShowCmd("remove_path", name, value, sep)
end

function M.load(self, ...)
   ShowCmd("load",...)
end

function M.try_load(self, ...)
   ShowCmd("try_load",...)
end

M.try_add = M.try_load

function M.inherit(self, ...)
   ShowCmd("inherit",...)
end

function M.family(self, ...)
   ShowCmd("family",...)
end

function M.display(self, ...)
   ShowCmd("display", ...)
end

function M.unload(self, ...)
   ShowCmd("unload", ...)
end

function M.prereq(self, ...)
   ShowCmd("prereq",...)
end

function M.conflict(self, ...)
   ShowCmd("conflict",...)
end

function M.prereq_any(self, ...)
   ShowCmd("prereq_any",...)
end

function M.error(self, ...)
   ShowCmd("LmodError", ...)
end

function M.message(self, ...)
   ShowCmd("LmodMessage", ...)
end

return M

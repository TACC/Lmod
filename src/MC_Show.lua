-- -*- lua -*-
require("strict")

MC_Show           = inheritsFrom(MasterControl)
MC_Show.my_name   = "MC_Show"

local M           = MC_Show
local Dbg         = require("Dbg")
local concatTbl   = table.concat

local function ShowCmd(name,...)
   local a = {}
   local s
   for _,v in ipairs{...} do
      if (type(v) == "boolean") then
         s = tostring(v)
      else
         s = "\"".. tostring(v) .."\""
      end
      a[#a + 1] = s
   end
   io.stderr:write(name,"(",concatTbl(a,", "),")\n")
end

local function Show_help(...)
   local a = {}
   for _,v in ipairs{...} do
      a[#a + 1] = "[[".. v .."]]"
   end
   io.stderr:write("help(",concatTbl(a,", "),")\n")
end

function M.help(self, ...)
   Show_help(...)
end

function M.whatis(self, value)
   ShowCmd("whatis", value)
end

function M.prepend_path(self, ...)
   ShowCmd("prepend_path", ...)
end

function M.add_property(self, name,value)
   ShowCmd("add_property", name, value)
end

function M.remove_property(self, name,value)
   ShowCmd("remove_property", name, value)
end

function M.set_alias(self, name,value)
   ShowCmd("set_alias", name, value)
end

function M.unset_alias(self, name)
   ShowCmd("unset_alias",name)
end

function M.append_path(self, ...)
   ShowCmd("append_path", ...)
end

function M.setenv(self, name,value)
   ShowCmd("setenv", name, value)
end

function M.unsetenv(self, name,value)
   ShowCmd("unsetenv", name, value)
end

function M.remove_path(self, name,value)
   ShowCmd("remove_path", name, value)
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

function M.required(self, ...)
   ShowCmd("required",...)
end

function M.conflict(self, ...)
   ShowCmd("conflict",...)
end

return M

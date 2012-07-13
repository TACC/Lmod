-- -*- lua -*-
require("strict")

Show              = inheritsFrom(MasterControl)
Show.my_name      = "MC_Show"

local M           = Show
local Dbg         = require("Dbg")
local format      = string.format
local getenv      = os.getenv

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
   io.stderr:write("help","(",concatTbl(a,", "),")\n")
end

function M.help(self, ...)
   Show_help(...)
end

function M.whatis(self, value)
   ShowCmd("whatis", value)
end

function M.prepend_path(...)
   ShowCmd("prepend_path", ...)
end

function M.set_alias(name,value)
   ShowCmd("set_alias", name, value)
end

function M.unset_alias(name)
   ShowCmd("unset_alias",name)
end

function M.append_path(...)
   ShowCmd("append_path", ...)
end

function M.setenv(name,value)
   ShowCmd("setenv", name, value)
end

function M.unsetenv(name,value)
   ShowCmd("unsetenv", name, value)
end

function M.remove_path(name,value)
   ShowCmd("remove_path", name, value)
end

function M.load(...)
   ShowCmd("load",...)
end

function M.try_load(...)
   ShowCmd("try_load",...)
end

M.try_add = M.try_load

function M.inherit(...)
   ShowCmd("inherit",...)
end

function M.family(...)
   ShowCmd("family",...)
end

function M.display(...)
   ShowCmd("display",...)
end

function M.unload(...)
   ShowCmd("unload",...)
end

function M.prereq(...)
   ShowCmd("prereq",...)
end

function M.conflict(...)
   ShowCmd("conflict",...)
end

return M

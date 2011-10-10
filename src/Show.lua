local concatTbl = table.concat
function ShowCmd(name,...)
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

function Show_help(...)
   local a = {}
   for _,v in ipairs{...} do
      a[#a + 1] = "[[".. v .."]]"
   end
   io.stderr:write("help","(",concatTbl(a,", "),")\n")
end

function Show_use(value)
   ShowCmd("use", value)
end

function Show_whatis(value)
   ShowCmd("whatis", value)
end

function Show_unuse(value)
   ShowCmd("unuse", value)
end

function Show_prepend_path(name,value)
   ShowCmd("prepend_path", name, value)
end

function Show_set_alias(name,value)
   ShowCmd("set_alias", name, value)
end

function Show_unset_alias(name)
   ShowCmd("unset_alias",name)
end

function Show_append_path(name,value)
   ShowCmd("append_path", name, value)
end

function Show_set(name,value)
   ShowCmd("setenv", name, value)
end

function Show_unset(name,value)
   ShowCmd("unsetenv", name, value)
end

function Show_remove_path(name,value)
   ShowCmd("remove_path", name, value)
end

function Show_load(...)
   ShowCmd("load",...)
end

function Show_inherit(...)
   ShowCmd("inherit",...)
end

function Show_family(...)
   ShowCmd("family",...)
end

function Show_display(...)
   ShowCmd("display",...)
end

function Show_unload(...)
   ShowCmd("unload",...)
end

function Show_prereq(...)
   ShowCmd("prereq",...)
end

function Show_conflict(...)
   ShowCmd("conflict",...)
end

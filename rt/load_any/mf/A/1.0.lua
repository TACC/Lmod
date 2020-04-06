if (isDefined("load_any")) then
   io.stderr:write("The function \"load_any()\" is defined!\n")
end
if (isNotDefined("load_anything")) then
   io.stderr:write("The function \"load_anything()\" is NOT defined!\n")
end

load_any("foo","FOO","Foo")

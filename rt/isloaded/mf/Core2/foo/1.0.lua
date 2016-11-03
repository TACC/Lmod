setenv("FOO",myModuleVersion())
if (mode() == "loaded") then
   io.stderr:write("Foo version: ",myModuleVersion(),"\n")
end


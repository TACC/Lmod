if (mode() == "load") then
   local result = userInGroup("vasp")
   io.stderr:write('userInGroup("vasp"):          ', tostring(result),"\n")
   local result = userInGroups("vasp")
   io.stderr:write('userInGroups("vasp"):         ', tostring(result),"\n")
   local result = userInGroups("Vasp")
   io.stderr:write('userInGroups("Vasp"):         ', tostring(result),"\n")
   local result = userInGroups("build","vasp")
   io.stderr:write('userInGroups("build","vasp"): ', tostring(result),"\n")
   local result = userInGroups("Build","vasp")
   io.stderr:write('userInGroups("Build","vasp"): ', tostring(result),"\n")
   local result = userInGroups("Build","Vasp")
   io.stderr:write('userInGroups("Build","Vasp"): ', tostring(result),"\n")
end

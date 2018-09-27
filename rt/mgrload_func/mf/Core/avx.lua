if (mode() == "load") then
   local required = false
   local activeA = loaded_modules()
   
   for i = 1,#activeA do
      io.stderr:write("Unloading: ",activeA[i].userName,"\n")
      unload(activeA[i].userName)
   end
   setenv("RSNT_ARCH","avx")
   for i = 1,#activeA do
      io.stderr:write("loading: ",activeA[i].userName,"\n")
      mgrload(required, activeA[i])
   end
end

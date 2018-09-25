if (mode() == "load") then
   local required = false
   local a = loaded_modules()
   
   for i = 1,#a do
      io.stderr:write("Unloading: ",a[i].fullName,"\n")
      unload(a[i].userName)
   end
   setenv("RSNT_ARCH","avx")
   for i = 1,#a do
      io.stderr:write("loading: ",a[i].fullName,"\n")
      mgrload(required, a[i].userName)
   end
end

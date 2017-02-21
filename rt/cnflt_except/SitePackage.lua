function conflict_except(name)
   
   ------------------------------------------------------------
   -- This function only makes sense when loading a modulefile.
   if (mode() ~= "load") then
      return
   end


   ------------------------------------------------------------
   -- Return a list of the loaded modules.
   -- Each entry in mA has sn, fullName, fn as keys.
   local mA = loaded_modules()  

   if (#mA > 1) then
      LmodError("Too many modules: only one is allowed")
   end

   local entry = mA[1]
   if (entry.sn ~= name and entry.fullName ~= name) then
      LmodError("Expected ",name," got ", entry.fullName, " instead!")
   end
end

sandbox_registration{ conflict_except = conflict_except }

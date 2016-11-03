if (mode() == "load" or mode() == "show" ) then
   if ( not (isloaded("noweb") ) ) then
      load("noweb")
   end
   if ( not (isloaded("git") ) ) then
      load("git")
   end
 end

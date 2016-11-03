if (mode() == "load") then
   if ( isloaded("intel") ) then
      io.stderr:write("Found intel\n")
   end

   if ( isloaded("foo") ) then
      io.stderr:write("Found foo\n")
   end
   if ( isloaded("foo/1.0") ) then
      io.stderr:write("Found foo/1.0\n")
   end
   if ( isloaded("foo/2.0") ) then
      io.stderr:write("Found foo/2.0\n")
   end
   if ( isloaded("bar") ) then
      io.stderr:write("Found bar\n")
   end
   if ( isloaded("bar/3.1.4") ) then
      io.stderr:write("Found bar/3.1.4\n")
   end
end

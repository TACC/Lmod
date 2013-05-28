--------------------------------------------------------------------------
-- string:split():  An iterator to loop split a pieces.  This code is
--                  from the lua-users.org/lists/lua-l/2006-12/msg00414.html
--

require("strict")
function string:split(pat)
   pat  = pat or "%s+"
   local st, g = 1, self:gmatch("()("..pat..")")
   local function getter(self, segs, seps, sep, cap1, ...)
      st = sep and seps + #sep
      return self:sub(segs, (seps or 0) - 1), cap1 or sep, ...
   end
   local function splitter(self)
      if st then return getter(self, st, g()) end
   end
   return splitter, self
end

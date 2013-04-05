-- $Id$ --

function string:trim()
   local ja = self:find("%S")
   if (ja == nil) then
      return ""
   end
   local  jb = self:find("%s+$") or 0
   local  s  = self:sub(ja,jb-1)
   return s
end


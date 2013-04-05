require("strict")
require("capture")
local term    = false
local s_width = false
if (pcall(require,"term")) then
   term = require("term")
end

function TermWidth()
   if (s_width) then
      return s_width
   end
   s_width = tonumber(capture("tput cols")) or 80

   if (term) then
      if (not term.isatty(io.stderr)) then
         s_width = 80
      end
   end

   return s_width
end

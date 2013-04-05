-- $Id$
require("strict")
require("string_split")

local concatTbl = table.concat

function fillWords(indent,line,width)
   local a   = {}
   local ia  = 0
   local len = 0

   ia = ia + 1; a[ia] = indent; len = len + indent:len()

   for word in line:split("[ \n]+") do
      local wlen = word:len()
      if (wlen + len >= width) then
         ia = ia + 1; a[ia] = "\n";
         ia = ia + 1; a[ia] = indent; len = indent:len()
      end
      ia = ia + 1; a[ia] = word;
      ia = ia + 1; a[ia] = " ";
      len = len + wlen + 1
   end
   return concatTbl(a,"")
end

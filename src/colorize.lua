require("strict")
Foreground = "\027".."[1;"
colorT =
   {
   black      = "30",
   red        = "31",
   green      = "32",
   yellow     = "33",
   blue       = "34",
   magenta    = "35",
   cyan       = "36",
   white      = "37",
}
local concatTbl = table.concat

function full_colorize(color, ... )
   local arg = { n = select('#', ...), ...}
   if (color == nil or arg.n < 1) then
      return plain(color, ...)
   end

   local a = {}
   a[#a+1] = Foreground
   a[#a+1] = colorT[color]
   a[#a+1] = 'm'

   for i = 1, arg.n do
      a[#a+1] = arg[i]
   end
   a[#a+1] = "\027" .. "[0m"

   return concatTbl(a,"")
end

function plain(c, ...)
   local arg = { n = select('#', ...), ...}
   if (arg.n < 1) then
      return ""
   end
   local a = {}
   for i = 1, arg.n do
      a[#a+1] = arg[i]
   end
   return concatTbl(a,"")
end


--module('Version')
local M={}
function M.tag()  return "5.9.3.2"   end
function M.git()
   local s = "@git@"
   if (s == "@" .. "git@")     then s = "" end
   if (s == "("..M.tag()..")") then s = "" end
   return s
end
function M.date() return "2015-04-11 14:15" end
function M.name()
  local a = {}
  a[#a+1] = M.tag()
  a[#a+1] = M.git()
  a[#a+1] = M.date()
  return table.concat(a," ")
end
return M

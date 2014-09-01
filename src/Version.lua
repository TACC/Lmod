--module('Version')
local M={}
function M.tag()  return "5.7.5.1"   end
function M.git()
   local s = "@git@"
   if (s == "@" .. "git@") then s = "" end
   return s
end
function M.date() return "2014-09-01 13:28" end
function M.name()
  local a = {}
  a[#a+1] = M.tag()
  a[#a+1] = M.git()
  a[#a+1] = M.date()
  return table.concat(a," ")
end
return M

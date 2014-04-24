--module('Version')
local M={}
function M.tag()  return "5.5rc1"   end
function M.git()  return "@git@"    end
function M.date() return "2014-04-24 17:42" end
function M.name()
  local a = {}
  a[#a+1] = M.tag()
  a[#a+1] = M.git()
  a[#a+1] = M.date()
  return table.concat(a," ")
end
return M

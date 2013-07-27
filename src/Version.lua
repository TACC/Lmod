--module('Version')
local M={}
function M.tag()  return "5.1.1"   end
function M.date() return "2013-07-27 00:30" end
function M.git()  return "(@git@)"  end
function M.name()
  local a = {}
  a[#a+1] = M.tag()
  a[#a+1] = M.git()
  a[#a+1] = M.date()
  return table.concat(a," ")
end
return M

--module('Version')
local M={}
function M.tag()  return "5.1.9"   end
function M.date() return "2013-10-07 22:10" end
function M.git()  return "(@git@)"  end
function M.name()
  local a = {}
  a[#a+1] = M.tag()
  a[#a+1] = M.git()
  a[#a+1] = M.date()
  return table.concat(a," ")
end
return M

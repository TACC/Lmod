local M={}
function M.tag()  return "7.8.2"   end
function M.git()
   local s = "@git@"
   if (s == "@" .. "git@")     then s = "" end
   if (s == "("..M.tag()..")") then s = "" end
   return s
end
function M.date() return "2018-08-17 14:56 -05:00" end
function M.name()
  local a = {}
  a[#a+1] = M.tag()
  a[#a+1] = M.git()
  a[#a+1] = M.date()
  return table.concat(a," ")
end
return M

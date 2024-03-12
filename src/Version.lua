local M={}
function M.branch()
   return "main"
end
function M.branchStr()
   local s = M.branch()
   if (s == "main") then
      s = ""
   end
   return s == "" and s or "[branch: "..s.."]"
end
function M.tag()  return "<tag>"   end
function M.git()
   local s = "<git_tag>"
   if (s == "@" .. "git@") then s = "" end
   if (s == M.tag()      ) then s = "" end
   return s == "" and s or "("..s..")"
end
function M.date() return "<date>" end
function M.name()
  local a = {}
  a[#a+1] = M.tag()
  a[#a+1] = M.git()
  a[#a+1] = M.branchStr()
  a[#a+1] = M.date()
  return table.concat(a," ")
end
return M

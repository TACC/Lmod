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
function M.tag()  return "8.7.65"   end
function M.git()
   local s = "8.7.65"
   if (s == "@" .. "git@") then s = "" end
   if (s == M.tag()      ) then s = "" end
   return s == "" and s or "("..s..")"
end
function M.date() return "2025-08-05 10:24 -06:00" end
function M.name()
  local a = {}
  a[#a+1] = M.tag()
  a[#a+1] = M.git()
  a[#a+1] = M.branchStr()
  a[#a+1] = M.date()
  local b = {}
  for i = 1,#a do
     if (a[i] ~= "") then
        b[#b+1] = a[i]
     end
  end
  return table.concat(b," ")
end
return M

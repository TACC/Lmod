local a = { "good.text", "bad1.text", "bad2.text"}

for i = 1,#a do
   local result = isFile(a[i])
   io.stderr:write(a[i].."   "..tostring(result).."\n")
end


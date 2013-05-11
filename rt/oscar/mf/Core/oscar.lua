help("\tThis module sets up the OSCAR modules subsystem.")
whatis("Description: Sets up the OSCAR modules subsystem.")
local mroot = os.getenv("MODULEPATH_ROOT")
local oscarDir = pathJoin(mroot,"Oscar")
prepend_path("MODULEPATH", oscarDir)

local a = {}

for file in lfs.dir(oscarDir) do
   if (file ~= "." and file ~= ".." and file:sub(-1,-1) ~= '~') then
      a[#a+1] = file
   end
end

table.sort(a)

for i = 1,#a do
   load(a[i])
end



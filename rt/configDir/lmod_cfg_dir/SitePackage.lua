
local function echo2(s)
   io.stderr:write(s,"\n")
end

sandbox_registration {
   echo2 = echo2
}

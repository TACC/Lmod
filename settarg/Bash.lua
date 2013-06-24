-- -*- lua -*-
local BaseShell = BaseShell
local io        = io
local pairs     = pairs
local assert    = assert
local concat    = table.concat
Bash            = inheritsFrom(BaseShell)
Bash.my_name    = 'bash'
local systemG   = _G

function Bash.expand(self, tbl)

   for k in pairs(tbl) do
      local v     = tbl[k]
      local lineA = {}
      if (v == '') then
         io.stdout:write("unset '",k,"';\n")
      else
         lineA[#lineA + 1] = k
         lineA[#lineA + 1] = "='"
         lineA[#lineA + 1] = v
         lineA[#lineA + 1] = "';\n"
         lineA[#lineA + 1] = "export "
         lineA[#lineA + 1] = k
         lineA[#lineA + 1] = ";\n"
         local line = concat(lineA,"")
         io.stdout:write(line)
      end
   end
end

return Bash

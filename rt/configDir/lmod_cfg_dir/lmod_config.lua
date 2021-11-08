require("strict")
local cosmic       = require("Cosmic"):singleton()

cosmic:assign("LMOD_SITE_NAME", "XYZZY")

local function echoString(s)
   io.stderr:write(s,"\n")
end

sandbox_registration {
   echoString = echoString
}

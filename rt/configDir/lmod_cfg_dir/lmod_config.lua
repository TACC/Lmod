require("strict")
local cosmic       = require("Cosmic"):singleton()
local testDir      = os.getenv("testDir")

cosmic:assign("LMOD_PACKAGE_PATH",  pathJoin(testDir,"lmod_cfg_dir"))
cosmic:assign("LMOD_SITE_MSG_FILE", pathJoin(testDir,"lmod_cfg_dir/lang.lua"))

cosmic:assign("LMOD_SITE_NAME", "XYZZY")


local function echoString(s)
   io.stderr:write(s,"\n")
end

sandbox_registration {
   echoString = echoString
}

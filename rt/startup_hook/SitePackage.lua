local dbg   = require("Dbg"):dbg()
local hook  = require("Hook")
local function startup_hook(usrCmd)
    -- This hook is called right after starting Lmod
    -- usrCmd holds the currect active command
    -- if you want access to all give arguments, use
    -- masterTbl
   io.stderr:write("Received usrCmd: \"", usrCmd, "\"\n")
end

hook.register("startup", startup_hook)

local base        = "@PKG@/settarg"
local settarg_cmd = pathJoin(base, "settarg_cmd")

prepend_path("PATH",base)
pushenv("LMOD_SETTARG_CMD", settarg_cmd)
set_shell_function("settarg", 'eval $($LMOD_SETTARG_CMD -s sh "$@")',
                              'eval `$LMOD_SETTARG_CMD  -s csh $*`' )

set_alias("cdt", "cd $TARG")
set_shell_function("targ",  'builtin echo $TARG', 'echo $TARG')
setenv("TARGET_PREFIX", "TARG/")

if (os.getenv("LMOD_SETTARG_SUPPORT"):lower() == "full") then
   set_shell_function("dbg",   'settarg "$@" dbg',   'settarg $* dbg')
   set_shell_function("empty", 'settarg "$@" empty', 'settarg $* empty')
   set_shell_function("opt",   'settarg "$@" opt',   'settarg $* opt')
   set_shell_function("mdbg",  'settarg "$@" mdbg',  'settarg $* mdbg')
end


if (mode() == "unload") then
   local myShell = myShellName()
   local cmd     = "eval `" .. settarg_cmd .. " -s " .. myShell .. " --destroy`"
   execute(cmd)
end

local helpMsg = [[
Settarg Help Message:

]]

help(helpMsg)

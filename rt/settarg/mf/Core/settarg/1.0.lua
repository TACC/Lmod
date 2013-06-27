local projDir    = os.getenv("projectDir")
local settarg_cmd = pathJoin(projDir, "settarg", "settarg_cmd.in.lua")

setenv("LMOD_SETTARG_CMD", "lua " .. settarg_cmd)
set_shell_function("settarg", 'eval $($LMOD_SETTARG_CMD --shell sh "$@")',
   'eval `$LMOD_SETTARG_CMD  --shell csh $*`')

set_shell_function("dbg",  'settarg "$@" dbg',   'settarg dbg  $*')
set_shell_function("opt",  'settarg "$@" opt',   'settarg opt  $*')
set_shell_function("mdbg", 'settarg "$@" mdbg',  'settarg mdbg $*')
set_shell_function("targ", 'builtin echo $TARG', 'echo $TARG')
set_alias("cdt", "cd $TARG")

if (mode() == "unload") then
   local myShell = myShellName()
   local cmd     = "eval `lua " .. settarg_cmd .. " -s " .. myShell .. " --purge`"
   execute(cmd)
end

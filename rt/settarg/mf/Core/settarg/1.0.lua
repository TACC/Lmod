local projDir    = os.getenv("projectDir")
local settarg_cmd = pathJoin(projDir, "settarg", "settarg_cmd.in.lua")

local respect = true
setenv("SETTARG_TAG1", "OBJ", respect)
setenv("SETTARG_TAG2", "_"  , respect)
setenv("LMOD_SETTARG_CMD", "lua " .. settarg_cmd)
set_shell_function("settarg", 'eval $($LMOD_SETTARG_CMD --shell sh "$@")',
   'eval `$LMOD_SETTARG_CMD  --shell csh $*`')

set_shell_function("dbg",         'settarg "$@" dbg',   'settarg $* dbg  ')
set_shell_function("empty",       'settarg "$@" empty', 'settarg $* empty')
set_shell_function("opt",         'settarg "$@" opt',   'settarg $* opt  ')
set_shell_function("mdbg",        'settarg "$@" mdbg',  'settarg $* mdbg ')
set_shell_function("targ",        'builtin echo $TARG', 'echo $TARG')
set_shell_function("gettargdir",  'builtin echo $TARG', 'echo $TARG')
set_alias("cdt", "cd $TARG")

local myShell = myShellName()
local cmd     = "eval `lua " .. settarg_cmd .. " -s " .. myShell .. " --destroy`"
execute{cmd=cmd,modeA={"unload"}}



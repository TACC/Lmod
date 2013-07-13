local base        = "@PKG@/settarg"
local settarg_cmd = pathJoin(base, "settarg_cmd")

prepend_path("PATH",base)
pushenv("LMOD_SETTARG_CMD", settarg_cmd)
set_shell_function("settarg", 'eval $($LMOD_SETTARG_CMD -s sh "$@")',
                              'eval `$LMOD_SETTARG_CMD  -s csh $*`' )

set_alias("cdt", "cd $TARG")
set_shell_function("targ",        'builtin echo $TARG', 'echo $TARG')
set_shell_function("gettargdir",  'builtin echo $TARG', 'echo $TARG')

local respect = "true"
setenv("SETTARG_TAG1", "OBJ", respect )
setenv("SETTARG_TAG2", "_"  , respect )

if ((os.getenv("LMOD_SETTARG_SUPPORT") or ""):lower() == "full") then
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

-- You must change base to match the location of where the settarg
-- command is.


--local base        = "/opt/apps/lmod/lmod/settarg"
local settarg_cmd = pathJoin(base, "settarg_cmd")

setenv("TARGET_PREFIX","ST_OBJ/")
prepend_path("PATH",base)
pushenv("LMOD_SETTARG_CMD", settarg_cmd)
set_shell_function("settarg", 'eval $($LMOD_SETTARG_CMD -s sh "$@")',
                              'eval `$LMOD_SETTARG_CMD  -s csh $*`')

------------------------------------------------------------------------
-- Useful aliases/shell function
--   set_shell_function("dbg",   'settarg "$@" dbg',   'settarg $* dbg')
--   set_shell_function("empty", 'settarg "$@" empty', 'settarg $* empty')
--   set_shell_function("opt",   'settarg "$@" opt',   'settarg $* opt')
--   set_shell_function("mdbg",  'settarg "$@" mdbg',  'settarg $* mdbg')

set_shell_function("targ",  'builtin echo $TARG', 'echo $TARG')
set_alias("cdt", "cd $TARG")

if (mode() == "unload") then
   local myShell = myShellName()
   local cmd     = "eval `" .. settarg_cmd .. " -s " .. myShell .. " --destroy`"
   execute(cmd)
end

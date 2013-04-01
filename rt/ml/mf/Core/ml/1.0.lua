local bashStr = 'eval $($LMOD_DIR/ml_cmd "$@")'
local cshStr  = "eval `$LMOD_DIR/ml_cmd $*`"
set_shell_function("ml",bashStr,cshStr)
append_path("LMOD_ALIAS_LIST",myModuleName())


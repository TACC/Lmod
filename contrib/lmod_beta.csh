
foreach i ( ~mclay/l/pkg/`uname -m` ~mclay/l/pkg)
    if ( -d $i/luatools ) then
      set PKG_DIR=$i
      break;
    endif
end

setenv LUA_PATH  "$PKG_DIR/luatools/luatools/share/5.1/?.lua;;"
setenv LUA_CPATH "$PKG_DIR/luatools/luatools/lib/5.1/?.so;;"

setenv LMOD_CMD $PKG_DIR/lmod/lmod/libexec/lmod
setenv ML_DIR   $PKG_DIR/lmod/lmod/libexec/

setenv BASH_ENV $PKG_DIR/lmod/lmod/init/bash

alias module  'eval `'$PKG_DIR/lmod/lmod/libexec/lmod' csh \!*`'
alias ml      'eval `'$ML_DIR/ml_cmd' \!*`'
alias getmt   $PKG_DIR/lmod/lmod/libexec/getmt

MCLAY=~mclay

for i in $MCLAY/l/pkg/$(uname -m) $MCLAY/l/pkg; do
  if [ -x $i/lmod/lmod/libexec/lmod ]; then
    PKG_DIR=$i
    break
  fi
done

#export LUA_PATH="$PKG_DIR/luatools/luatools/share/5.1/?.lua;;"
#export LUA_CPATH="$PKG_DIR/luatools/luatools/lib/5.1/?.so;;"
export LMOD_DIR=$PKG_DIR/lmod/lmod/libexec
export LMOD_CMD=$LMOD_DIR/lmod

export BASH_ENV=$PKG_DIR/lmod/lmod/init/bash

ml () {
  eval $($LMOD_DIR/ml_cmd "$@")
}

module () {
    eval $($LMOD_CMD bash "$@")
}


module purge
clearMT
module --initial_load restore

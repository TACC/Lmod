MCLAY=~mclay

for i in $MCLAY/l/pkg/$(uname -m) $MCLAY/l/pkg; do
  if [ -d $i/luatools ]; then  
    PKG_DIR=$i
    break
  fi
done

export LUA_PATH="$PKG_DIR/luatools/luatools/share/5.1/?.lua;;"
export LUA_CPATH="$PKG_DIR/luatools/luatools/lib/5.1/?.so;;"

export LMOD_CMD=$PKG_DIR/lmod/lmod/libexec/lmod
ML_DIR=$PKG_DIR/lmod/lmod/libexec/

export BASH_ENV=$PKG_DIR/lmod/lmod/init/bash

ml () {
  eval $($ML_DIR/ml_cmd "$@")
}

module () {
    eval $($LMOD_CMD bash "$@")
}


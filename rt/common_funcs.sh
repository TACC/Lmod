cleanUp ()
{
   gitV=$(git describe --always)
   local old
   local new
   old="Lmod Warning: Syntax error in file: ProjectDIR"
   new="Lmod Warning: Syntax error in file:\nProjectDIR"

   sed                                                    \
       -e "s|:$PATH_to_LUA:|:|g"                          \
       -e "s|$PATH_to_LUA/lua|lua|g"                      \
       -e "s|\@git\@|$gitV|g"                             \
       -e "s|:/bin:|:|g"                                  \
       -e "s|:/usr/bin:|:|g"                              \
       -e "s|:/usr/local/bin:|:|g"                        \
       -e "s|:$PATH_to_SHA1:|:|g"                         \
       -e "s|^Lmod version.*||g"                          \
       -e "s|^Lua Version.*||g"                           \
       -e "s|^\(uname -a\).*|\1|g"                        \
       -e "s|^\(TARG_HOST=\).*|\1''|g"                    \
       -e "s|^\(TARG_OS_FAMILY=\).*|\1''|g"               \
       -e "s|^\(TARG_OS=\).*|\1''|g"                      \
       -e "s|^\(TARG_MACH_DESCRIPT=\).*|\1''|g"           \
       -e "s|$PATH_to_TM|PATH_to_TM|g"                    \
       -e "s|^LD_PRELOAD at config time.*$||g"            \
       -e "s|^LD_LIBRARY_PATH at config time.*$||g"       \
       -e "s|unsetenv _ModuleTable..._;||g"               \
       -e "s|unset _ModuleTable..._;||g"                  \
       -e "s|unset _ModuleTable..._;||g"                  \
       -e "s|$outputDir|OutputDIR|g"                      \
       -e "s|$projectDir|ProjectDIR|g"                    \
       -e "s|^Admin file.*||g"                            \
       -e "s|^MODULERCFILE.*||g"                          \
       -e "s|$HOME|~|g"                                   \
       -e "s|\-%%\-.*||g"                                 \
       -e "s| *----* *||g"                                \
       -e "s|^--* *| |g"                                  \
       -e "s|--* *$||g"                                   \
       -e "s|$old|$new|g"                                 \
       -e "s|^ *OutputDIR| OutputDIR|"                    \
       -e "s|  *$||g"                                     \
       -e "/^Active lua-term.*/d"                         \
       -e "/Rebuilding cache.*done/d"                     \
       -e "/Using your spider cache file/d"               \
       -e "/^_ModuleTable_Sz_=.*$/d"                      \
       -e "/^setenv _ModuleTable_Sz_ .*$/d"               \
       -e "/^ *$/d"                                       \
       < $1 > $2
}
runBase ()
{
   COUNT=$(($COUNT + 1))
   numStep=$(($numStep+1))
   NUM=`printf "%03d" $numStep`
   echo "===========================" >  _stderr.$NUM
   echo "step $COUNT"                 >> _stderr.$NUM
   echo "$@"                          >> _stderr.$NUM
   echo "===========================" >> _stderr.$NUM

   echo "===========================" >  _stdout.$NUM
   echo "step $COUNT"                 >> _stdout.$NUM
   echo "$@"                          >> _stdout.$NUM
   echo "===========================" >> _stdout.$NUM

   numStep=$(($numStep+1))
   NUM=`printf "%03d" $numStep`
   "$@" > _stdout.$NUM 2>> _stderr.$NUM
}

runMe ()
{
   runBase "$@"
   eval `cat _stdout.$NUM`
}
runLmod ()
{
   runBase $LUA_EXEC $projectDir/src/lmod.in.lua bash --regression_testing "$@"
   eval `cat _stdout.$NUM`
}

runSh2MF ()
{
   runBase $LUA_EXEC $projectDir/src/sh_to_modulefile.in.lua "$@"
}

buildModuleT ()
{
   $LUA_EXEC $projectDir/src/spider.in.lua -o moduleT "$@"
}

buildDbT ()
{
   $LUA_EXEC $projectDir/src/spider.in.lua -o dbT     "$@"
}

buildRmapT ()
{
   $LUA_EXEC $projectDir/src/spider.in.lua -o reverseMapT "$@"
}

buildNewDB()
{
   local DIR=$1
   local tsfn=$2
   local file=$3
   local option=$file

   if [ ! -d $DIR ]; then
     mkdir -p $DIR
   fi


   local LmodV=$(lua -e 'print((_VERSION:gsub("Lua ","")))')
   local OLD=$DIR/$file.old.lua
   local NEW=$DIR/$file.new.lua
   local RESULT=$DIR/$file.lua

   local OLD_C=$DIR/$file.old.luac_$LmodV
   local NEW_C=$DIR/$file.new.luac_$LmodV
   local RESULT_C=$DIR/$file.luac_$LmodV

   rm -f $OLD $NEW
   $LMOD_DIR/spider --timestampFn $tsfn -o $option $BASE_MODULE_PATH > $NEW
   if [ "$?" = 0 ]; then
      chmod 644 $NEW
      if [ -f $RESULT ]; then
        cp -p $RESULT $OLD
      fi
      mv $NEW $RESULT

      luac -o $NEW_C $RESULT

      chmod 644 $NEW_C
      if [ -f $RESULT_C ]; then
        cp -p $RESULT_C $OLD_C
      fi
      mv $NEW_C $RESULT_C
   fi
}

EPOCH()
{
   $LUA_EXEC $projectDir/src/epoch.in.lua
}

initStdEnvVars()
{
  unset CPATH
  unset DYLD_LIBRARY_PATH
  unset INCLUDE
  unset INFOPATH
  unset INTEL_LICENSE_FILE
  unset LD_LIBRARY_PATH
  unset LIBPATH
  unset LIBRARY_PATH
  unset LMOD_ADMIN_FILE
  unset LMOD_COLORIZE
  unset LMOD_DEFAULT_MODULEPATH
  unset LMOD_EXPERT
  unset LMOD_OPTIONS
  unset LMOD_PIN_VERSIONS
  unset LMOD_QUIET
  unset LMOD_SYSTEM_DEFAULT_MODULES
  unset LMOD_TERM_WIDTH
  unset LOADEDMODULES
  unset MANPATH
  unset MODULEPATH
  unset MODULEPATH_ROOT
  unset MODULERCFILE
  unset NLSPATH
  unset OMP_NUM_THREADS
  unset PYTHONPATH
  unset SHLIB_PATH
  unset _LMFILES_
  unset __LMOD_PRIORITY_PATH
  export LMOD_PREPEND_BLOCK=yes
  PATH_to_LUA=`findcmd --pathOnly lua`
  PATH_to_TM=`findcmd --pathOnly tm`
  PATH_to_SHA1=`findcmd --pathOnly sha1sum`
  LUA_EXEC=$PATH_to_LUA/lua
  numStep=0
  COUNT=0
  ORIG_HOME=`(cd $HOME; /bin/pwd)`
  HOME=`/bin/pwd`
  export LMOD_TERM_WIDTH=300

  export PATH=$projectDir/src:$PATH_to_LUA:$PATH_to_TM:$PATH_to_SHA1:/usr/bin:/bin

}

clearTARG()
{
  unset BUILDTARGET
  unset TARG
  unset TARGET_PREFIX
  unset TARG_COMPILER
  unset TARG_COMPILER_FAMILY
  unset TARG_MACH
  unset TARG_BUILD_SCENARIO
  unset TARG_MPI
  unset TARG_MPI_FAMILY
  unset TARG_TARGET
}


unsetMT ()
{
   unset _ModuleTable_
   local last
   last=1000
   if [ -n "$_ModuleTable_Sz_" ]; then
       last=$_ModuleTable_Sz_
       unset _ModuleTable_Sz_
   fi
   for ((i=1; i<=last; i++)); do
      num=`printf %03d $i`
      eval j="\$_ModuleTable${num}_"
      if [ -z "$j" ]; then
         break
      fi
      unset _ModuleTable${num}_
   done
}

unsetSTT ()
{
   unset _SettargTable_
   local last
   last=1000
   if [ -n "$_SettargTable_Sz_" ]; then
       last=$_SettargTable_Sz_
       unset _SettargTable_Sz_
   fi
   for ((i=1; i<=last; i++)); do
      num=`printf %03d $i`
      eval j="\$_SettargTable${num}_"
      if [ -z "$j" ]; then
         break
      fi
      unset _SettargTable${num}_
   done
}

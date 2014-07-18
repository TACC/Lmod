cleanUp ()
{
   gitV=$(git describe --always)

   sed                                                    \
       -e "s|:$PATH_to_LUA:|:|g"                          \
       -e "s|$PATH_to_LUA/lua|lua|g"                      \
       -e "s|\@git\@|$gitV|g"                             \
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
       -e "s|unsetenv _ModuleTable..._;||g"               \
       -e "s|unset _ModuleTable..._;||g"                  \
       -e "s|unset _ModuleTable..._;||g"                  \
       -e "s|$outputDir|OutputDIR|g"                      \
       -e "s|$projectDir|ProjectDIR|g"                    \
       -e "s| *\-\-\-\-* *||g"                            \
       -e "s|\-%%\-.*||g"                                 \
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
   NUM=`printf "%02d" $numStep`
   echo "===========================" >  _stderr.$NUM
   echo "step $COUNT"                 >> _stderr.$NUM
   echo "$@"                          >> _stderr.$NUM
   echo "===========================" >> _stderr.$NUM

   echo "===========================" >  _stdout.$NUM
   echo "step $COUNT"                 >> _stdout.$NUM
   echo "$@"                          >> _stdout.$NUM
   echo "===========================" >> _stdout.$NUM

   numStep=$(($numStep+1))
   NUM=`printf "%02d" $numStep`
   "$@" > _stdout.$NUM 2>> _stderr.$NUM
}

runMe ()
{
   runBase "$@"
   eval `cat _stdout.$NUM`
}
runLmod ()
{
   runBase $LUA_EXEC $projectDir/src/lmod.in.lua bash "$@"
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

EPOCH()
{
   $LUA_EXEC $projectDir/src/epoch.in.lua
}

initStdEnvVars()
{
  unset LIBPATH
  unset SHLIB_PATH
  unset INFOPATH
  unset MANPATH
  unset INCLUDE
  unset CPATH
  unset INTEL_LICENSE_FILE
  unset LIBRARY_PATH
  unset NLSPATH
  unset LD_LIBRARY_PATH
  unset DYLD_LIBRARY_PATH
  unset MODULEPATH
  unset LMOD_DEFAULT_MODULEPATH
  unset MODULEPATH_ROOT
  unset LMOD_EXPERT
  unset LMOD_QUIET
  unset LMOD_SYSTEM_DEFAULT_MODULES
  unset LMOD_TERM_WIDTH
  unset PYTHONPATH
  unset LMOD_COLORIZE
  unset LMOD_OPTIONS
  unset _LMFILES_
  unset LOADEDMODULES
  unset __LMOD_PRIORITY_PATH
  export LMOD_PREPEND_BLOCK=yes
  PATH_to_LUA=`findcmd --pathOnly lua`
  PATH_to_TM=`findcmd --pathOnly tm`
  PATH_to_SHA1=`findcmd --pathOnly sha1sum`
  LUA_EXEC=$PATH_to_LUA/lua


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

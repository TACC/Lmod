cleanUp ()
{
   gitV=$(git describe --always)

   sed                                                    \
       -e "s|:$PATH_to_LUA:|:|g"                          \
       -e "s|\@git\@|$gitV|g"                             \
       -e "s|:/usr/bin:|:|g"                              \
       -e "s|:/usr/local/bin:|:|g"                        \
       -e "s|:$PATH_to_SHA1:|:|g"                         \
       -e "s|$PATH_to_TM|PATH_to_TM|g"                    \
       -e "s|unsetenv _ModuleTable..._;||g"               \
       -e "s|unset _ModuleTable..._;||g"                  \
       -e "s|unset _ModuleTable..._;||g"                  \
       -e "s|$projectDir|ProjectDIR|g"                    \
       -e "s| *\-\-\-\-* *||g"                            \
       -e "/Rebuilding cache file, please wait .* done/d" \
       -e "/Using your spider cache file/d"               \
       -e "/^_ModuleTable_Sz_=.*$/d"                      \
       -e "/^setenv _ModuleTable_Sz_ .*$/d"               \
       -e "/^ *$/d"                                       \
       < $1 > $2
}
runBase ()
{
   COUNT=`expr $COUNT + 1`
   numStep=`expr $numStep + 1`
   NUM=`printf "%02d" $numStep`
   echo "===========================" >  _stderr.$NUM
   echo "step $COUNT"                 >> _stderr.$NUM
   echo "===========================" >> _stderr.$NUM

   echo "===========================" >  _stdout.$NUM
   echo "step $COUNT"                 >> _stdout.$NUM
   echo "===========================" >> _stdout.$NUM

   numStep=`expr $numStep + 1`
   NUM=`printf "%02d" $numStep`
   "$@" > _stdout.$NUM 2>> _stderr.$NUM
}
runMe ()
{
   runBase "$@"
   eval `cat _stdout.$NUM`
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
  unset LMOD_SYSTEM_DEFAULT_MODULES
  export LMOD_PREPEND_BLOCK=yes
  PATH_to_LUA=`findcmd --pathOnly lua`
  PATH_to_TM=`findcmd --pathOnly tm`
  PATH_to_SHA1=`findcmd --pathOnly sha1sum`

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
  unset TARG_METHOD
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
   for i in `seq 1 $last`; do
      num=`printf %03d $i`
      eval j="\$_ModuleTable${num}_"
      if [ -z "$j" ]; then
         break
      fi
      unset _ModuleTable${num}_
   done
}

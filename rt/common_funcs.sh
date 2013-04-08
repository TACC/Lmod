cleanUp ()
{
   sed                                                    \
       -e "s|:$PATH_to_LUA:|:|g"                          \
       -e "s|:/usr/bin:|:|g"                              \
       -e "s|:/usr/local/bin:|:|g"                        \
       -e "s|$PATH_to_TM|PATH_to_TM|g"                    \
       -e "s|unsetenv _ModuleTable..._;||g"               \
       -e "s|unset _ModuleTable..._;||g"                  \
       -e "s|unset _ModuleTable..._;||g"                  \
       -e "s|$projectDir|ProjectDIR|g"                    \
       -e "s|----*||g"                                    \
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
  unset INFOPATH
  unset MANPATH
  unset LD_LIBRARY_PATH
  unset MODULEPATH
  unset LMOD_DEFAULT_MODULEPATH
  unset MODULEPATH_ROOT
  unset LMOD_EXPERT
  export LMOD_PREPEND_BLOCK=yes
  PATH_to_LUA=`findcmd --pathOnly lua`
  PATH_to_TM=`findcmd --pathOnly tm`

  export PATH=$projectDir/src:$PATH_to_LUA:$PATH_to_TM:/usr/bin:/bin
  
}


unsetMT ()
{
   unset _ModuleTable_
   for i in `seq 1 1000`; do
      num=`printf %03d $i`
      eval j="\$_ModuleTable${num}_"
      if [ -z "$j" ]; then
         break
      fi
      unset _ModuleTable${num}_
   done
}


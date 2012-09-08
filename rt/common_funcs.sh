cleanUp ()
{
   sed                                                    \
       -e "s|:$PATH_to_LUA:|:|g"                          \
       -e "s|:/usr/bin:|:|g"                              \
       -e "s|$PATH_to_TM|PATH_to_TM|g"                    \
       -e "s|unsetenv _ModuleTable..._;||g"               \
       -e "s|unset _ModuleTable..._;||g"                  \
       -e "s|unset _ModuleTable..._;||g"                  \
       -e "s|$projectDir|ProjectDIR|g"                    \
       -e "s|---*||g"                                     \
       -e "/Rebuilding cache file, please wait .* done/d" \
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


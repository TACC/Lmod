# SYNOPSIS
#
#   Summarizes configuration settings.
#
#   AX_SUMMARIZE_CONFIG([, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]]])
#
# DESCRIPTION
#
#   Outputs a summary of relevant configuration settings.
#

AC_DEFUN([AX_SUMMARIZE_CONFIG],
[

echo
echo '----------------------------------- SUMMARY ----------------------------------'
echo
echo "Package version............................." : Lmod-$LmodV
echo
echo "LUA_INCLUDE................................." : $LUA_INCLUDE
echo "Lua executable.............................." : $luaprog
echo "Install dir................................." : $prefix
echo
echo "MODULEPATH_ROOT............................." : $MODULEPATH_ROOT
echo "Wait (s) before rebuilting cache............" : $ANCIENT
echo "Do not save Cache if build time < .........." : $SHORT_TIME
echo "SPIDER_CACHE_DIRS..........................." : $SPIDER_CACHE_DIRS
echo "Prepending multiple dirs (NORMAL / REVERSED)" : $PREPEND_BLOCK
echo "Colorized output supported.................." : $COLORIZE
echo "File that is touched when system is updated." : $UPDATE_SYSTEM_FN
echo "Allow duplicate entry in PATHs.............." : $DUPLICATE_PATHS
echo "ZSH Tab Completion Functions Site Directory." : $ZSH_SITE_FUNCTIONS_DIR
echo "Use Dot files in ~/.lmod.d.................." : $USE_DOT_FILES
echo "Full Settarg support........................" : $SETTARG

echo
echo '------------------------------------------------------------------------------'

echo
echo Configure complete, now type \'make\' and then \'make install\'.
echo

])


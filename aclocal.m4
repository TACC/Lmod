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
echo "Package version (git) ......................" : $lmodV
echo
echo "LUA_INCLUDE................................." : $LUA_INCLUDE
echo "Lua executable.............................." : $luaprog
echo "Prefix......................................" : $prefix
echo "Actual Install dir.........................." : $prefix/lmod/$LmodV
echo
echo "MODULEPATH_ROOT............................." : $MODULEPATH_ROOT
echo "Wait (s) before rebuilting cache............" : $ANCIENT
echo "Allow Duplicate Paths......................." : $DUPLICATE_PATHS
echo "Do not save Cache if build time < .........." : $SHORT_TIME
echo "SPIDER_CACHE_DIRS..........................." : $SPIDER_CACHE_DIRS
echo "Prepending multiple dirs (NORMAL / REVERSED)" : $PREPEND_BLOCK
echo "Colorized output supported.................." : $COLORIZE
echo "File that is touched when system is updated." : $UPDATE_SYSTEM_FN
echo "Allow duplicate entry in PATHs.............." : $DUPLICATE_PATHS
echo "Allow tcl modulefiles......................." : $ALLOW_TCL_MFILES
echo "ZSH Tab Completion Functions Site Directory." : $ZSH_SITE_FUNCTIONS_DIR
echo "Use Dot files in ~/.lmod.d.................." : $USE_DOT_FILES
echo "Full Settarg support........................" : $SETTARG

echo
echo '------------------------------------------------------------------------------'
echo
echo '******************************************************************************'
echo
echo Lmod overwrites the env var BASH_ENV to make the module command available in
echo bash scripts.  If your site does not set BASH_ENV then you can ignore the
echo comments below.
echo
echo If your site already uses BASH_ENV to point to a site specific script, please
echo consider sourcing Lmod\'s init/bash from your site\'s file.
echo
echo BASH_ENV is defined both in:
echo "   $prefix/lmod/$LmodV/init/profile"
echo "   $prefix/lmod/$LmodV/init/cshrc"
echo
echo '******************************************************************************'


echo
echo Configure complete, now type \'make\' and then \'make install\'.
echo

])


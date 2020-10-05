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

LFS_STATUS="Built-in"
if test "$HAVE_LUAFILESYSTEM" = yes; then
  LFS_STATUS="system"
fi

MY_PACKAGE=$prefix/lmod/$LmodV
if test "$SITE_CONTROLLED_PREFIX" != no ; then
  MY_PACKAGE=$prefix
fi

echo
echo '----------------------------------- SUMMARY ----------------------------------'
echo
echo "Package version............................................." : Lmod-$LmodV
echo "Package version (git) ......................................" : $lmodV
echo 
echo "LUA_INCLUDE................................................." : $LUA_INCLUDE
echo "Lua executable.............................................." : $luaprog
echo "Luac executable............................................." : $PATH_TO_LUAC
echo "User Controlled Prefix......................................" : $SITE_CONTROLLED_PREFIX
echo "Prefix......................................................" : $prefix
echo "Actual Install dir.........................................." : $MY_PACKAGE
echo 
echo "MODULEPATH_ROOT............................................." : $MODULEPATH_ROOT
echo "Wait (s) before rebuilding cache............................" : $ANCIENT
echo "Allow Duplicate Paths......................................." : $DUPLICATE_PATHS
echo "Do not save Cache if build time < .........................." : $SHORT_TIME
echo "SPIDER_CACHE_DIRS..........................................." : $SPIDER_CACHE_DIRS
echo "Prepending multiple dirs (NORMAL / REVERSED)................" : $PREPEND_BLOCK
echo "Colorized output supported.................................." : $COLORIZE
echo "File that is touched when system is updated................." : $UPDATE_SYSTEM_FN
echo "Allow duplicate entry in PATHs.............................." : $DUPLICATE_PATHS
echo "Allow tcl modulefiles......................................." : $ALLOW_TCL_MFILES
echo "ZSH Tab Completion Functions Site Directory................." : $ZSH_SITE_FUNCTIONS_DIRS
echo "Use Dot files in ~/.lmod.d.................................." : $USE_DOT_FILES
echo "Full Settarg support........................................" : $SETTARG
echo "Have lua-term..............................................." : $HAVE_LUA_TERM
echo "Have luafilesystem.........................................." : $HAVE_LUAFILESYSTEM
echo "Support Auto Swap when using families......................." : $AUTO_SWAP
echo "Export the module shell function in Bash...................." : $EXPORT_MODULE
echo "Disable same name autoswapping.............................." : $DISABLE_NAME_AUTOSWAP
echo "Use Spider Cache on Loads..................................." : $CACHED_LOADS
echo "Pager used inside Lmod......................................" : $PATH_TO_PAGER
echo "System LD_PRELOAD..........................................." : $SYS_LD_PRELOAD
echo "System LD_LIBRARY_PATH......................................" : $SYS_LD_LIB_PATH
echo "Hashsum program used........................................" : $PATH_TO_HASHSUM
echo "Site Name..................................................." : $SITE_NAME
echo "SYSHOST....................................................." : $SYSHOST
echo "Site Message file..........................................." : $SITE_MSG_FILE
echo 'Override $LANG Language for error etc.......................' : $LMOD_OVERRIDE_LANG
echo "Which LuaFileSystem is being used..........................." : $LFS_STATUS
echo 'Use italic instead of faint for hidden modules..............' : $HIDDEN_ITALIC
echo "If path entry is already there then don't prepend..........." : $TMOD_PATH_RULE
echo "Use Tmod Find First rule instead of Find Best for defaults.." : $TMOD_FIND_FIRST
echo "MODULEPATH Initial file....................................." : $MODULEPATH_INIT
echo "Use built-in lua packages instead of system provided pkgs..." : $USE_BUILT_IN_PKGS
echo "Silence shell debugging output for bash/zsh................." : $SILENCE_SHELL_DEBUGGING
echo "Allow root to use Lmod......................................" : $LMOD_ALLOW_ROOT_USE
echo "Support KSH................................................." : $SUPPORT_KSH
echo "Use the fast TCL interpreter................................" : $FAST_TCL_INTERP
echo "Allow for extended default.(ml intel/17 #-> intel/17.0.4)..." : $EXTENDED_DEFAULT  #"

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
echo "   $MY_PACKAGE/init/profile"
echo "   $MY_PACKAGE/init/cshrc"
echo
echo '******************************************************************************'
echo

a=$(echo $EXPORT_MODULE | tr ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz)

if test "$a" != no; then
  echo
  echo '******************************************************************************'
  echo
  echo Lmod is exporting the module command for Bash users.  Some sites may have some
  echo problems.  First:
  echo
  echo "   0.  Make sure that all your machines have shellshock bash patch."
  echo
  echo If that does not fix things then you have two choices:
  echo
  echo "   1.  You configure Lmod not to export the module command."
  echo "   2.  You can filter out the exported functions in the users environment"
  echo "       during job submission"
  echo
  echo If there is a way to do step 2, please try to do so.  Otherwise do step 1.
  echo The advantage of exporting the module command is that it is defined in
  echo /bin/sh scripts. Because Lmod defines BASH_ENV to point to init/bash,
  echo "it will be defined for /bin/bash scripts.  The trouble is that users"
  echo "have to remember to put #!/bin/bash at the first line of their shell"
  echo script to make that work.    We used to see tickets where users would
  echo submit jobs as /bin/sh scripts and wonder why the module command did
  echo not work.
  echo
  echo '******************************************************************************'
  echo
fi

if test $SITE_CONTROLLED_PREFIX != no ; then
   echo
   echo '**********************************************************************'
   echo ' '
   echo 'Warning: you have chosen to control the prefix.  This means that '
   echo '         you must update any Lmod scripts in /etc/profile.d'
   echo ' '
   echo '**********************************************************************'
fi


echo
echo Configure complete, Now do:
echo
echo "    $ make install       # -> A complete install"
echo or
echo "    $ make pre-install   # -> Install everything but the symbolic link"
echo

])


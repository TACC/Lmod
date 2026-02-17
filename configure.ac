dnl Process this file with autoconf to produce a configure script.
dnl This is for lmod

AC_INIT
AC_CONFIG_SRCDIR([Makefile.in])
AC_PREFIX_DEFAULT(/usr/local)
AC_PROG_CC

VALID_YN ()
{
  ANS=$1
  MSG=$2
  case $ANS in
    yes|no)
      ;;
    *)
      echo $MSG
      exit 1
      ;;
  esac
}

FOLLOW_READLINK ()
{
  myprog=$1
  oldprog=$1
  while test -L $myprog; do
    myprog=$(readlink $myprog)
    if test ${myprog:0:1} != '/' ; then
       d=$(dirname $oldprog)
       myprog="$d/$myprog"
       CWD=$(pwd)
       d=$(dirname $myprog)
       b=$(basename $myprog)
       cd $d
       d=$(pwd)
       myprog="$d/$b"
       cd $CWD
     fi
     oldprog=$myprog
  done
  echo $myprog
}

ERR_MSG=""
FOUND_ERROR=
SRCDIR=$( cd $srcdir; pwd)
PATH_TO_SRC=$SRCDIR

AC_SUBST(DUPLICATE_PATHS)
AC_ARG_WITH(duplicatePaths,
    AS_HELP_STRING([--with-duplicatePaths=ans],[Allow duplicate directories in path like variables [[no]]]),
    DUPLICATE_PATHS="$withval"
    DUPLICATE_PATHS=`echo $DUPLICATE_PATHS | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $DUPLICATE_PATHS "--with-duplicatePaths=ans: ans must be yes or no"
    AC_MSG_RESULT([DUPLICATE_PATHS=$with_duplicatePaths])
    AC_DEFINE_UNQUOTED(DUPLICATE_PATHS,"$with_duplicatePaths")dnl
    ,
    withval="no"
    AC_MSG_RESULT([DUPLICATE_PATHS=$withval])
    DUPLICATE_PATHS="$withval"
    AC_DEFINE_UNQUOTED(DUPLICATE_PATHS, "$withval"))dnl

AC_SUBST(LMOD_ALLOW_ROOT_USE)
AC_ARG_WITH(allowRootUse,
    AS_HELP_STRING([--with-allowRootUse=ans],[Allow root to use Lmod [[yes]]]),
    LMOD_ALLOW_ROOT_USE="$withval"
    LMOD_ALLOW_ROOT_USE=`echo $LMOD_ALLOW_ROOT_USE | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $LMOD_ALLOW_ROOT_USE "--with-allowRootUse=ans: ans must be yes or no"
    AC_MSG_RESULT([LMOD_ALLOW_ROOT_USE=$with_allowRootUse])
    AC_DEFINE_UNQUOTED(LMOD_ALLOW_ROOT_USE,"$with_allowRootUse")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([LMOD_ALLOW_ROOT_USE=$withval])
    LMOD_ALLOW_ROOT_USE="$withval"
    AC_DEFINE_UNQUOTED(LMOD_ALLOW_ROOT_USE, "$withval"))dnl

AC_SUBST(SITE_MSG_FILE)
AC_ARG_WITH(siteMsgFile,
    AS_HELP_STRING([--with-siteMsgFile=ans],[Site Message File [[<empty>]]]),
    SITE_MSG_FILE="$withval"
    AC_MSG_RESULT([SITE_MSG_FILE=$with_siteMsgFile])
    AC_DEFINE_UNQUOTED(SITE_MSG_FILE,"$with_siteMsgFile")dnl
    ,
    withval="<empty>"
    AC_MSG_RESULT([SITE_MSG_FILE=$withval])
    SITE_MSG_FILE="$withval"
    AC_DEFINE_UNQUOTED(SITE_MSG_FILE, "$withval"))dnl

AC_SUBST(LMOD_OVERRIDE_LANG)
AC_ARG_WITH(lang,
    AS_HELP_STRING([--with-lang=ans],[Override $LANG for Lmod errors/messages/warnings [[<empty>]]]),
    LMOD_OVERRIDE_LANG="$withval"
    AC_MSG_RESULT([LMOD_OVERRIDE_LANG=$with_lang])
    AC_DEFINE_UNQUOTED(LMOD_OVERRIDE_LANG,"$with_lang")dnl
    ,
    withval="<empty>"
    AC_MSG_RESULT([LMOD_OVERRIDE_LANG=$withval])
    LMOD_OVERRIDE_LANG="$withval"
    AC_DEFINE_UNQUOTED(LMOD_OVERRIDE_LANG, "$withval"))dnl

AC_SUBST(CASE_INDEPENDENT_SORTING)
AC_ARG_WITH(caseIndependentSorting,
    AS_HELP_STRING([--with-caseIndependentSorting=ans],[Make avail and spider use case independent sorting [[no]]]),
    CASE_INDEPENDENT_SORTING="$withval"
    CASE_INDEPENDENT_SORTING=`echo $CASE_INDEPENDENT_SORTING | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $CASE_INDEPENDENT_SORTING "--with-caseIndependentSorting=ans: ans must be yes or no"
    AC_MSG_RESULT([CASE_INDEPENDENT_SORTING=$with_caseIndependentSorting])
    AC_DEFINE_UNQUOTED(CASE_INDEPENDENT_SORTING,"$with_caseIndependentSorting")dnl
    ,
    withval="no"
    AC_MSG_RESULT([CASE_INDEPENDENT_SORTING=$withval])
    CASE_INDEPENDENT_SORTING="$withval"
    AC_DEFINE_UNQUOTED(CASE_INDEPENDENT_SORTING, "$withval"))dnl

AC_SUBST(COLORIZE)
AC_ARG_WITH(colorize,
    AS_HELP_STRING([--with-colorize=ans],[allow for colorized output [[yes]]]),
    COLORIZE="$withval"
    COLORIZE=`echo $COLORIZE | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $COLORIZE "--with-colorize=ans: ans must be yes or no"
    AC_MSG_RESULT([COLORIZE=$with_colorize])
    AC_DEFINE_UNQUOTED(COLORIZE, "$with_colorize")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([COLORIZE=$withval])
    COLORIZE="$withval"
    AC_DEFINE_UNQUOTED(COLORIZE, "$withval"))dnl

AC_SUBST(DYNAMIC_SPIDER_CACHE)
AC_ARG_WITH(dynamicSpiderCache,
    AS_HELP_STRING([--with-dynamicSpiderCache=ans],[allow for Dynamic Spider Cache usage [[yes]]]),
    DYNAMIC_SPIDER_CACHE="$withval"
    DYNAMIC_SPIDER_CACHE=`echo $DYNAMIC_SPIDER_CACHE | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $DYNAMIC_SPIDER_CACHE "--with-dynamicSpiderCache=ans: ans must be yes or no"
    AC_MSG_RESULT([DYNAMIC_SPIDER_CACHE=$with_dynamicSpiderCache])
    AC_DEFINE_UNQUOTED(DYNAMIC_SPIDER_CACHE, "$with_dynamicSpiderCache")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([DYNAMIC_SPIDER_CACHE=$withval])
    DYNAMIC_SPIDER_CACHE="$withval"
    AC_DEFINE_UNQUOTED(DYNAMIC_SPIDER_CACHE, "$withval"))dnl

AC_SUBST(HIDDEN_ITALIC)
AC_ARG_WITH(hiddenItalic,
    AS_HELP_STRING([--with-hiddenItalic=ans],[Use italic for hidden module instead of faint[[no]]]),
    HIDDEN_ITALIC="$withval"
    HIDDEN_ITALIC=`echo $HIDDEN_ITALIC | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $HIDDEN_ITALIC "--with-hiddenItalic=ans: ans must be yes or no"
    AC_MSG_RESULT([HIDDEN_ITALIC=$with_hiddenItalic])
    AC_DEFINE_UNQUOTED(HIDDEN_ITALIC, "$with_hiddenItalic")dnl
    ,
    withval="no"
    AC_MSG_RESULT([HIDDEN_ITALIC=$withval])
    HIDDEN_ITALIC="$withval"
    AC_DEFINE_UNQUOTED(HIDDEN_ITALIC, "$withval"))dnl

AC_SUBST(EXACT_MATCH)
AC_ARG_WITH(exactMatch,
    AS_HELP_STRING([--with-exactMatch=ans],[require exact match, disable defaults [[no]]]),
    EXACT_MATCH="$withval"
    EXACT_MATCH=`echo $EXACT_MATCH | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $EXACT_MATCH "--with-exactMatch=ans: ans must be yes or no"
    AC_MSG_RESULT([EXACT_MATCH=$with_exactMatch])
    AC_DEFINE_UNQUOTED(EXACT_MATCH, "$with_exactMatch")dnl
    ,
    withval="no"
    AC_MSG_RESULT([EXACT_MATCH=$withval])
    EXACT_MATCH="$withval"
    AC_DEFINE_UNQUOTED(EXACT_MATCH, "$withval"))dnl

AC_SUBST(MODE)
AC_ARG_WITH(mode,
    AS_HELP_STRING([--with-mode=ans],[Override executable install mode (755 or 750 or 700) [[user_default]]]),
    MODE="$withval"
    MODE=`echo $MODE | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    AC_MSG_RESULT([MODE=$with_mode])
    AC_DEFINE_UNQUOTED(MODE, "$with_mode")dnl
    ,
    withval="user_default"
    AC_MSG_RESULT([MODE=$withval])
    MODE="$withval"
    AC_DEFINE_UNQUOTED(MODE, "$withval"))dnl

AC_SUBST(LMOD_CONFIG_DIR)
AC_ARG_WITH(lmodConfigDir,
    AS_HELP_STRING([--with-lmodConfigDir=ans],[Location of Lmod Config Dir [[/etc/lmod]]]),
    LMOD_CONFIG_DIR="$withval"
    AC_MSG_RESULT([LMOD_CONFIG_DIR=$with_lmodConfigDir])
    AC_DEFINE_UNQUOTED(LMOD_CONFIG_DIR, "$with_lmodConfigDir")dnl
    ,
    withval="/etc/lmod"
    AC_MSG_RESULT([LMOD_CONFIG_DIR=$withval])
    LMOD_CONFIG_DIR="$withval"
    AC_DEFINE_UNQUOTED(LMOD_CONFIG_DIR, "$withval"))dnl

AC_SUBST(AUTO_SWAP)
AC_ARG_WITH(autoSwap,
    AS_HELP_STRING([--with-autoSwap=ans],[Allow auto swapping of compiler etc. [[yes]]]),
    AUTO_SWAP="$withval"
    AUTO_SWAP=`echo $AUTO_SWAP | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $AUTO_SWAP "--with-autoSwap=ans: ans must be yes or no"
    AC_MSG_RESULT([AUTO_SWAP=$with_autoSwap])
    AC_DEFINE_UNQUOTED(AUTO_SWAP, "$with_autoSwap")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([AUTO_SWAP=$withval])
    AUTO_SWAP="$withval"
    AC_DEFINE_UNQUOTED(AUTO_SWAP, "$withval"))dnl

AC_SUBST(EXPORT_MODULE)
AC_ARG_WITH(exportedModuleCmd,
    AS_HELP_STRING([--with-exportedModuleCmd=ans],[Export the module command. [[yes]]]),
    with_exportedModuleCmd=`echo $with_exportedModuleCmd | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    withval=$with_exportedModuleCmd
    EXPORT_MODULE="$withval"
    EXPORT_MODULE=`echo $EXPORT_MODULE | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $EXPORT_MODULE "--with-exportedModuleCmd=ans: ans must be yes or no"
    AC_MSG_RESULT([EXPORT_MODULE=$with_exportedModuleCmd])
    AC_DEFINE_UNQUOTED(EXPORT_MODULE, "$with_exportedModuleCmd")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([EXPORT_MODULE=$withval])
    EXPORT_MODULE="$withval"
    AC_DEFINE_UNQUOTED(EXPORT_MODULE, "$withval"))dnl

AC_SUBST(REDIRECT)
AC_ARG_WITH(redirect,
    AS_HELP_STRING([--with-redirect=ans],[redirect messages to stdout [[no]]]),
    REDIRECT="$withval"
    REDIRECT=`echo $REDIRECT | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $REDIRECT "--with-redirect=ans: ans must be yes or no"
    AC_MSG_RESULT([REDIRECT=$with_redirect])
    AC_DEFINE_UNQUOTED(REDIRECT, "$with_redirect")dnl
    ,
    withval="no"
    AC_MSG_RESULT([REDIRECT=$withval])
    REDIRECT="$withval"
    AC_DEFINE_UNQUOTED(REDIRECT, "$withval"))dnl

AC_SUBST(MODULEPATH_ROOT)dnl
AC_ARG_WITH(module-root-path,
    AS_HELP_STRING([--with-module-root-path=<path>],[use module root path=<path> [[PREFIX/modulefiles]]]),
    MODULEPATH_ROOT="$withval"
    AC_MSG_RESULT([MODULEPATH_ROOT=$with_module_root_path])
    AC_DEFINE_UNQUOTED(MODULEPATH_ROOT, "$with_module_root_path")dnl
    ,
    withval="$prefix/modulefiles"
    AC_MSG_RESULT([MODULEPATH_ROOT=$withval])
    MODULEPATH_ROOT="$withval"
    AC_DEFINE_UNQUOTED(MODULEPATH_ROOT, "$withval"))dnl

AC_SUBST(ANCIENT)
AC_ARG_WITH(ancient,
    AS_HELP_STRING([--with-ancient=num_secs],[How long to wait before rebuilding spider cache file=num_secs [[86400]]]),
    ANCIENT="$withval"
    AC_MSG_RESULT([ANCIENT=$with_ancient])
    AC_DEFINE_UNQUOTED(ANCIENT, "$with_ancient")dnl
    ,
    withval="86400"
    AC_MSG_RESULT([ANCIENT=$withval])
    ANCIENT="$withval"
    AC_DEFINE_UNQUOTED(ANCIENT, "$withval"))dnl

AC_SUBST(SHORT_TIME)
AC_ARG_WITH(shortTime,
    AS_HELP_STRING([--with-shortTime=seconds],[if spider build time < shortTime then no spider cache file [[2]]]),
    SHORT_TIME="$withval"
    AC_MSG_RESULT([SHORT_TIME=$with_shortTime])
    AC_DEFINE_UNQUOTED(SHORT_TIME, "$with_shortTime")dnl
    ,
    withval="2"
    AC_MSG_RESULT([SHORT_TIME=$withval])
    SHORT_TIME="$withval"
    AC_DEFINE_UNQUOTED(SHORT_TIME, "$withval"))dnl

AC_SUBST(SPIDER_CACHE_DIRS)
AC_ARG_WITH(spiderCacheDir,
    AS_HELP_STRING([--with-spiderCacheDir=dir1:dir2],[use these directories to hold a spider cache file [[]]]),
    SPIDER_CACHE_DIRS="$withval"
    AC_MSG_RESULT([SPIDER_CACHE_DIRS=$with_spiderCacheDir])
    AC_DEFINE_UNQUOTED(SPIDER_CACHE_DIRS, "$with_spiderCacheDir")dnl
    ,
    withval=""
    AC_MSG_RESULT([SPIDER_CACHE_DIRS=$withval])
    SPIDER_CACHE_DIRS="$withval"
    AC_DEFINE_UNQUOTED(SPIDER_CACHE_DIRS, "$withval"))dnl

AC_SUBST(SPIDER_CACHE_DESCRIPT_FN)
AC_ARG_WITH(spiderCacheDescript,
    AS_HELP_STRING([--with-spiderCacheDescript=fn],[Use specified file to describe cache directory and timestamp files [[]]]),
    SPIDER_CACHE_DESCRIPT_FN="$withval"
    AC_MSG_RESULT([SPIDER_CACHE_DESCRIPT_FN=$with_spiderCacheDescript])
    AC_DEFINE_UNQUOTED(SPIDER_CACHE_DESCRIPT_FN, "$with_spiderCacheDescript")dnl
    ,
    withval=""
    AC_MSG_RESULT([SPIDER_CACHE_DESCRIPT_FN=$withval])
    SPIDER_CACHE_DESCRIPT_FN="$withval"
    AC_DEFINE_UNQUOTED(SPIDER_CACHE_DESCRIPT_FN, "$withval"))dnl

AC_SUBST(UPDATE_SYSTEM_FN)
AC_ARG_WITH(updateSystemFn,
    AS_HELP_STRING([--with-updateSystemFn=file],[This file is touched when the system has been updated [[]]]),
    UPDATE_SYSTEM_FN="$withval"
    AC_MSG_RESULT([UPDATE_SYSTEM_FN=$with_updateSystemFn])
    AC_DEFINE_UNQUOTED(UPDATE_SYSTEM_FN, "$with_updateSystemFn")dnl
    ,
    withval=""
    AC_MSG_RESULT([UPDATE_SYSTEM_FN=$withval])
    UPDATE_SYSTEM_FN="$withval"
    AC_DEFINE_UNQUOTED(UPDATE_SYSTEM_FN, "$withval"))dnl

AC_SUBST(PREPEND_BLOCK)
AC_ARG_WITH(prependBlock,
    AS_HELP_STRING([--with-prependBlock=ans],[Treat multiple directories passed to prepend in normal order/ not reversed [[NORMAL]]]),
    PREPEND_BLOCK="$withval"
    AC_MSG_RESULT([PREPEND_BLOCK=$with_prependBlock])
    AC_DEFINE_UNQUOTED(PREPEND_BLOCK, "$with_prependBlock")dnl
    ,
    withval="normal"
    AC_MSG_RESULT([PREPEND_BLOCK=$withval])
    PREPEND_BLOCK="$withval"
    AC_DEFINE_UNQUOTED(PREPEND_BLOCK, "$withval"))dnl

AC_SUBST(SITE_NAME)
AC_ARG_WITH(siteName,
    AS_HELP_STRING([--with-siteName=ans],[Site Name [[<empty>]]]),
    SITE_NAME="$withval"
    AC_MSG_RESULT([SITE_NAME=$with_siteName])
    AC_DEFINE_UNQUOTED(SITE_NAME, "$with_siteName")dnl
    ,
    withval='<empty>'
    AC_MSG_RESULT([SITE_NAME=$withval])
    SITE_NAME="$withval"
    AC_DEFINE_UNQUOTED(SITE_NAME, "$withval"))dnl

AC_SUBST(SYSHOST)
AC_ARG_WITH(syshost,
    AS_HELP_STRING([--with-syshost=ans],[Site Name [[<empty>]]]),
    SYSHOST="$withval"
    AC_MSG_RESULT([SYSHOST=$with_syshost])
    AC_DEFINE_UNQUOTED(SYSHOST, "$with_syshost")dnl
    ,
    withval='<empty>'
    AC_MSG_RESULT([SYSHOST=$withval])
    SYSHOST="$withval"
    AC_DEFINE_UNQUOTED(SYSHOST, "$withval"))dnl

AC_SUBST(ALLOW_TCL_MFILES)
AC_ARG_WITH(tcl,
    AS_HELP_STRING([--with-tcl=ans],[Allow TCL modulefiles [[yes]]]),
    ALLOW_TCL_MFILES="$withval"
    ALLOW_TCL_MFILES=`echo $ALLOW_TCL_MFILES | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $ALLOW_TCL_MFILES "--with-tcl=ans: ans must be yes or no"
    AC_MSG_RESULT([ALLOW_TCL_MFILES==$withval])
    AC_DEFINE_UNQUOTED(ALLOW_TCL_MFILES, "$withval")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([ALLOW_TCL_MFILES=$withval])
    ALLOW_TCL_MFILES="$withval"
    AC_DEFINE_UNQUOTED(ALLOW_TCL_MFILES, "$withval"))dnl

AC_SUBST(DISABLE_NAME_AUTOSWAP)
AC_ARG_WITH(disableNameAutoSwap,
    AS_HELP_STRING([--with-disableNameAutoSwap=ans],[disable one name rule autoswapping [[no]]]),
    DISABLE_NAME_AUTOSWAP="$withval"
    DISABLE_NAME_AUTOSWAP=`echo $DISABLE_NAME_AUTOSWAP | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $DISABLE_NAME_AUTOSWAP "--with-disableNameAutoSwap=ans: ans must be yes or no"
    AC_MSG_RESULT([DISABLE_NAME_AUTOSWAP==$withval])
    AC_DEFINE_UNQUOTED(DISABLE_NAME_AUTOSWAP, "$withval")dnl
    ,
    withval="no"
    AC_MSG_RESULT([DISABLE_NAME_AUTOSWAP=$withval])
    DISABLE_NAME_AUTOSWAP="$withval"
    AC_DEFINE_UNQUOTED(DISABLE_NAME_AUTOSWAP, "$withval"))dnl

AC_SUBST(MPATH_AVAIL)
AC_ARG_WITH(mpathSearch,
    AS_HELP_STRING([--with-mpathSearch=ans],[include modulepath directory name in avail searching [[no]]]),
    MPATH_AVAIL="$withval"
    MPATH_AVAIL=`echo $MPATH_AVAIL | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $MPATH_AVAIL "--with-mpathSearch=ans: ans must be yes or no"
    AC_MSG_RESULT([MPATH_AVAIL==$withval])
    AC_DEFINE_UNQUOTED(MPATH_AVAIL, "$withval")dnl
    ,
    withval="no"
    AC_MSG_RESULT([MPATH_AVAIL=$withval])
    MPATH_AVAIL="$withval"
    AC_DEFINE_UNQUOTED(MPATH_AVAIL, "$withval"))dnl

AC_SUBST(SETTARG)
AC_ARG_WITH(settarg,
    AS_HELP_STRING([--with-settarg=ans],[startup files fully support settarg [[no]]]),
    SETTARG="$withval"
    SETTARG=`echo $SETTARG | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $SETTARG "--with-settarg=ans: ans must be yes or no"
    AC_MSG_RESULT([SETTARG=$with_settarg])
    AC_DEFINE_UNQUOTED(SETTARG, "$with_settarg")dnl
    ,
    withval="no"
    AC_MSG_RESULT([SETTARG=$withval])
    SETTARG="$withval"
    AC_DEFINE_UNQUOTED(SETTARG, "$withval"))dnl

DFLT_IGNORE_DIRS=".svn,.git,.hg,.bzr"

AC_SUBST(IGNORE_DIRS)
AC_ARG_WITH(ignoreDirs,
    AS_HELP_STRING([--with-ignoreDirs=ans],[list of directories to ignore [[.svn,.git,.hg,.bzr]]]),
    IGNORE_DIRS="$withval"
    AC_MSG_RESULT([IGNORE_DIRS=$with_ignoreDirs])
    AC_DEFINE_UNQUOTED(IGNORE_DIRS, "$with_ignoreDirs")dnl
    ,
    withval="$DFLT_IGNORE_DIRS"
    AC_MSG_RESULT([IGNORE_DIRS=$withval])
    IGNORE_DIRS="$withval"
    AC_DEFINE_UNQUOTED(IGNORE_DIRS, "$withval"))dnl

AC_SUBST(PIN_VERSIONS)
AC_ARG_WITH(pinVersions,
    AS_HELP_STRING([--with-pinVersions=ans],[Save/Restore will use the current version instead of changing with the default.[[no]]]),
    PIN_VERSIONS="$withval"
    PIN_VERSIONS=`echo $PIN_VERSIONS | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $PIN_VERSIONS "--with-pinVersions=ans: ans must be yes or no"
    AC_MSG_RESULT([PIN_VERSIONS=$with_pinVersions])
    AC_DEFINE_UNQUOTED(PIN_VERSIONS, "$with_pinVersions")dnl
    ,
    withval="no"
    AC_MSG_RESULT([PIN_VERSIONS=$withval])
    PIN_VERSIONS="$withval"
    AC_DEFINE_UNQUOTED(PIN_VERSIONS, "$withval"))dnl

AC_SUBST(LMOD_DOWNSTREAM_CONFLICTS)
AC_ARG_WITH(downstreamConflicts,
    AS_HELP_STRING([--with-downstreamConflicts=ans],[module conflicts are remembered for later loads. [[no]]]),
    LMOD_DOWNSTREAM_CONFLICTS="$withval"
    LMOD_DOWNSTREAM_CONFLICTS=`echo $LMOD_DOWNSTREAM_CONFLICTS | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $LMOD_DOWNSTREAM_CONFLICTS "--with-downstreamConflicts=ans: ans must be yes or no"
    AC_MSG_RESULT([LMOD_DOWNSTREAM_CONFLICTS=$with_downstreamConflicts])
    AC_DEFINE_UNQUOTED(LMOD_DOWNSTREAM_CONFLICTS, "$with_downstreamConflicts")dnl
    ,
    withval="no"
    AC_MSG_RESULT([LMOD_DOWNSTREAM_CONFLICTS=$withval])
    LMOD_DOWNSTREAM_CONFLICTS="$withval"
    AC_DEFINE_UNQUOTED(LMOD_DOWNSTREAM_CONFLICTS, "$withval"))dnl

AC_SUBST(MODULES_AUTO_HANDLING)
AC_ARG_WITH(modulesAutoHandling,
    AS_HELP_STRING([--with-modulesAutoHandling=ans],[treat prereq() as depends_on(). [[no]]]),
    MODULES_AUTO_HANDLING="$withval"
    MODULES_AUTO_HANDLING=`echo $MODULES_AUTO_HANDLING | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $MODULES_AUTO_HANDLING "--with-modulesAutoHandling=ans: ans must be yes or no"
    AC_MSG_RESULT([MODULES_AUTO_HANDLING=$with_modulesAutoHandling])
    AC_DEFINE_UNQUOTED(MODULES_AUTO_HANDLING, "$with_modulesAutoHandling")dnl
    ,
    withval="no"
    AC_MSG_RESULT([MODULES_AUTO_HANDLING=$withval])
    MODULES_AUTO_HANDLING="$withval"
    AC_DEFINE_UNQUOTED(MODULES_AUTO_HANDLING, "$withval"))dnl

AC_SUBST(TMOD_PATH_RULE)
AC_ARG_WITH(tmodPathRule,
    AS_HELP_STRING([--with-tmodPathRule=ans],[If path entry is already there then do not append/prepend.[[no]]]),
    TMOD_PATH_RULE="$withval"
    TMOD_PATH_RULE=`echo $TMOD_PATH_RULE | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $TMOD_PATH_RULE "--with-tmodPathRule=ans: ans must be yes or no"
    AC_MSG_RESULT([TMOD_PATH_RULE=$with_tmodPathRule])
    AC_DEFINE_UNQUOTED(TMOD_PATH_RULE, "$with_tmodPathRule")dnl
    ,
    withval="no"
    AC_MSG_RESULT([TMOD_PATH_RULE=$withval])
    TMOD_PATH_RULE="$withval"
    AC_DEFINE_UNQUOTED(TMOD_PATH_RULE, "$withval"))dnl

AC_SUBST(TMOD_FIND_FIRST)
AC_ARG_WITH(tmodFindFirst,
    AS_HELP_STRING([--with-tmodFindFirst=ans],[Use Tmod Find First rule instead of Find Best for defaults.[[no]]]),
    TMOD_FIND_FIRST="$withval"
    TMOD_FIND_FIRST=`echo $TMOD_FIND_FIRST | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $TMOD_FIND_FIRST "--with-tmodFindFirst=ans: ans must be yes or no"
    AC_MSG_RESULT([TMOD_FIND_FIRST=$with_tmodFindFirst])
    AC_DEFINE_UNQUOTED(TMOD_FIND_FIRST, "$with_tmodFindFirst")dnl
    ,
    withval="no"
    AC_MSG_RESULT([TMOD_FIND_FIRST=$withval])
    TMOD_FIND_FIRST="$withval"
    AC_DEFINE_UNQUOTED(TMOD_FIND_FIRST, "$withval"))dnl

AC_SUBST(LUA_INCLUDE)
AC_ARG_WITH(lua_include,
    AS_HELP_STRING([--with-lua_include=ans],[Specify the lua include directory[[no]]]),
    LUA_INCLUDE="$withval"
    AC_MSG_RESULT([LUA_INCLUDE=$with_lua_include])
    AC_DEFINE_UNQUOTED(LUA_INCLUDE, "$with_lua_include")dnl
    ,
    withval="no"
    AC_MSG_RESULT([LUA_INCLUDE=$withval])
    LUA_INCLUDE="$withval"
    AC_DEFINE_UNQUOTED(LUA_INCLUDE, "$withval"))dnl

AC_SUBST(CACHED_LOADS)
AC_ARG_WITH(cachedLoads,
    AS_HELP_STRING([--with-cachedLoads=ans],[Use cache when loading modules. [[no]]]),
    CACHED_LOADS="$withval"
    CACHED_LOADS=`echo $CACHED_LOADS | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $CACHED_LOADS "--with-cachedLoads=ans: ans must be yes or no"
    AC_MSG_RESULT([CACHED_LOADS=$with_cachedLoads])
    AC_DEFINE_UNQUOTED(CACHED_LOADS, "$with_cachedLoads")dnl
    ,
    withval="no"
    AC_MSG_RESULT([CACHED_LOADS=$withval])
    CACHED_LOADS="$withval"
    AC_DEFINE_UNQUOTED(CACHED_LOADS, "$withval"))dnl

AC_SUBST(TERSE_DECORATIONS)
AC_ARG_WITH(terseDecorations,
    AS_HELP_STRING([--with-terseDecorations=ans],[Allow for terse listing to be decorated. [[yes]]]),
    TERSE_DECORATIONS="$withval"
    TERSE_DECORATIONS=`echo $TERSE_DECORATIONS | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $TERSE_DECORATIONS "--with-terseDecorations=ans: ans must be yes or no"
    AC_MSG_RESULT([TERSE_DECORATIONS=$with_terseDecorations])
    AC_DEFINE_UNQUOTED(TERSE_DECORATIONS, "$with_terseDecorations")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([TERSE_DECORATIONS=$withval])
    TERSE_DECORATIONS="$withval"
    AC_DEFINE_UNQUOTED(TERSE_DECORATIONS, "$withval"))dnl

AC_SUBST(EXTENDED_DEFAULT)
AC_ARG_WITH(extendedDefault,
    AS_HELP_STRING([--with-extendedDefault=ans],[Allow for extended default. [[yes]]]),
    EXTENDED_DEFAULT="$withval"
    EXTENDED_DEFAULT=`echo $EXTENDED_DEFAULT | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $EXTENDED_DEFAULT "--with-extendedDefault=ans: ans must be yes or no"
    AC_MSG_RESULT([EXTENDED_DEFAULT=$with_extendedDefault])
    AC_DEFINE_UNQUOTED(EXTENDED_DEFAULT, "$with_extendedDefault")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([EXTENDED_DEFAULT=$withval])
    EXTENDED_DEFAULT="$withval"
    AC_DEFINE_UNQUOTED(EXTENDED_DEFAULT, "$withval"))dnl

AC_SUBST(SUPPORT_KSH)
AC_ARG_WITH(supportKsh,
    AS_HELP_STRING([--with-supportKsh=ans],[Support KSH. [[no]]]),
    SUPPORT_KSH="$withval"
    SUPPORT_KSH=`echo $SUPPORT_KSH | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $SUPPORT_KSH "--with-supportKsh=ans: ans must be yes or no"
    AC_MSG_RESULT([SUPPORT_KSH=$with_supportKsh])
    AC_DEFINE_UNQUOTED(SUPPORT_KSH, "$with_supportKsh")dnl
    ,
    withval="no"
    AC_MSG_RESULT([SUPPORT_KSH=$withval])
    SUPPORT_KSH="$withval"
    AC_DEFINE_UNQUOTED(SUPPORT_KSH, "$withval"))dnl

AC_SUBST(MODULEPATH_INIT)
AC_ARG_WITH(ModulePathInit,
    AS_HELP_STRING([--with-ModulePathInit=ans],[File containing initial MODULEPATH directories]),
    MODULEPATH_INIT="$withval"
    AC_MSG_RESULT([MODULEPATH_INIT=$with_ModulePathInit])
    AC_DEFINE_UNQUOTED(MODULEPATH_INIT, "$with_ModulePathInit")dnl
    ,
    withval="@PKG@/init/.modulespath"
    AC_MSG_RESULT([MODULEPATH_INIT=$withval])
    MODULEPATH_INIT="$withval"
    AC_DEFINE_UNQUOTED(MODULEPATH_INIT, "$withval"))dnl

AC_SUBST(SITE_CONTROLLED_PREFIX)
AC_ARG_WITH(siteControlPrefix,
    AS_HELP_STRING([--with-siteControlPrefix=ans],[A site controlled prefix. [[no]]]),
    SITE_CONTROLLED_PREFIX="$withval"
    SITE_CONTROLLED_PREFIX=`echo $SITE_CONTROLLED_PREFIX | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $SITE_CONTROLLED_PREFIX "--with-siteControlPrefix=ans: ans must be yes or no"
    AC_MSG_RESULT([SITE_CONTROLLED_PREFIX=$with_siteControlPrefix])
    AC_DEFINE_UNQUOTED(SITE_CONTROLLED_PREFIX, "$with_siteControlPrefix")dnl
    ,
    withval="no"
    AC_MSG_RESULT([SITE_CONTROLLED_PREFIX=$withval])
    SITE_CONTROLLED_PREFIX="$withval"
    AC_DEFINE_UNQUOTED(SITE_CONTROLLED_PREFIX, "$withval"))dnl

AC_SUBST(USE_BUILT_IN_PKGS)
AC_ARG_WITH(useBuiltinPkgs,
    AS_HELP_STRING([--with-useBuiltinPkgs=ans],[Use Built-in lua package instead of system ones. [[no]]]),
    USE_BUILT_IN_PKGS="$withval"
    USE_BUILT_IN_PKGS=`echo $USE_BUILT_IN_PKGS | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $USE_BUILT_IN_PKGS "--with-useBuiltinPkgs=ans: ans must be yes or no"
    AC_MSG_RESULT([USE_BUILT_IN_PKGS=$with_useBuiltinPkgs])
    AC_DEFINE_UNQUOTED(USE_BUILT_IN_PKGS, "$with_useBuiltinPkgs")dnl
    ,
    withval="no"
    AC_MSG_RESULT([USE_BUILT_IN_PKGS=$withval])
    USE_BUILT_IN_PKGS="$withval"
    AC_DEFINE_UNQUOTED(USE_BUILT_IN_PKGS, "$withval"))dnl

AC_SUBST(USE_DOT_CONFIG_DIR_ONLY)
AC_ARG_WITH(useDotConfigDirOnly,
    AS_HELP_STRING([--with-useDotConfigDirOnly=ans],[Write collections to only ~/.config/lmod directory. [[no]]]),
    USE_DOT_CONFIG_DIR_ONLY="$withval"
    USE_DOT_CONFIG_DIR_ONLY=`echo $USE_DOT_CONFIG_DIR_ONLY | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $USE_DOT_CONFIG_DIR_ONLY "--with-useDotConfigDirOnly=ans: ans must be yes or no"
    AC_MSG_RESULT([USE_DOT_CONFIG_DIR_ONLY=$with_useDotConfigDirOnly])
    AC_DEFINE_UNQUOTED(USE_DOT_CONFIG_DIR_ONLY, "$with_useDotConfigDirOnly")dnl
    ,
    withval="no"
    AC_MSG_RESULT([USE_DOT_CONFIG_DIR_ONLY=$withval])
    USE_DOT_CONFIG_DIR_ONLY="$withval"
    AC_DEFINE_UNQUOTED(USE_DOT_CONFIG_DIR_ONLY, "$withval"))dnl

AC_SUBST(SILENCE_SHELL_DEBUGGING)
AC_ARG_WITH(silentShellDebugging,
    AS_HELP_STRING([--with-silentShellDebugging=ans],[When using set -xv in bash silence the output from lmod. [[yes]]]),
    SILENCE_SHELL_DEBUGGING="$withval"
    SILENCE_SHELL_DEBUGGING=`echo $SILENCE_SHELL_DEBUGGING | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $SILENCE_SHELL_DEBUGGING "--with-silentShellDebugging=ans: ans must be yes or no"
    AC_MSG_RESULT([SILENCE_SHELL_DEBUGGING=$with_silentShellDebugging])
    AC_DEFINE_UNQUOTED(SILENCE_SHELL_DEBUGGING, "$with_silentShellDebugging")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([SILENCE_SHELL_DEBUGGING=$withval])
    SILENCE_SHELL_DEBUGGING="$withval"
    AC_DEFINE_UNQUOTED(SILENCE_SHELL_DEBUGGING, "$withval"))dnl

AC_SUBST(FAST_TCL_INTERP)
AC_ARG_WITH(fastTCLInterp,
    AS_HELP_STRING([--with-fastTCLInterp=ans],[Use the fast TCL interpreter. [[yes]]]),
    FAST_TCL_INTERP="$withval"
    FAST_TCL_INTERP=`echo $FAST_TCL_INTERP | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $FAST_TCL_INTERP "--with-fastTCLInterp=ans: ans must be yes or no"
    AC_MSG_RESULT([FAST_TCL_INTERP=$with_fastTCLInterp])
    AC_DEFINE_UNQUOTED(FAST_TCL_INTERP, "$with_fastTCLInterp")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([FAST_TCL_INTERP=$withval])
    FAST_TCL_INTERP="$withval"
    AC_DEFINE_UNQUOTED(FAST_TCL_INTERP, "$withval"))dnl

AC_SUBST(NEARLY_FORBIDDEN_DAYS)
AC_ARG_WITH(nearlyForbiddenDays,
    AS_HELP_STRING([--with-nearlyForbiddenDays=ans],[Number of days before nearly forbidden message applies. [[14]]]),
    NEARLY_FORBIDDEN_DAYS="$withval"
    AC_MSG_RESULT([NEARLY_FORBIDDEN_DAYS=$with_nearlyForbiddenDays])
    AC_DEFINE_UNQUOTED(NEARLY_FORBIDDEN_DAYS, "$with_nearlyForbiddenDays")dnl
    ,
    withval="14"
    AC_MSG_RESULT([NEARLY_FORBIDDEN_DAYS=$withval])
    NEARLY_FORBIDDEN_DAYS="$withval"
    AC_DEFINE_UNQUOTED(NEARLY_FORBIDDEN_DAYS, "$withval"))dnl

AC_SUBST(MODULE_AUTO_HANDLING)
AC_ARG_WITH(moduleAutoHandling,
    AS_HELP_STRING([--with-moduleAutoHandling=ans],[Automatically replaces prereqs with depends_on. [[no]]]),
    MODULE_AUTO_HANDLING="$withval"
    MODULE_AUTO_HANDLING=`echo $MODULE_AUTO_HANDLING | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $MODULE_AUTO_HANDLING "--with-moduleAutoHandling=ans: ans must be yes or no"
    AC_MSG_RESULT([MODULE_AUTO_HANDLING=$with-moduleAutoHandling])
    AC_DEFINE_UNQUOTED(MODULE_AUTO_HANDLING, "$with-moduleAutoHandling")dnl
    ,
    withval="no"
    AC_MSG_RESULT([MODULE_AUTO_HANDLING=$withval])
    MODULE_AUTO_HANDLING="$withval"
    AC_DEFINE_UNQUOTED(MODULE_AUTO_HANDLING, "$withval"))dnl

AC_SUBST(AVAIL_EXTENSIONS)
AC_ARG_WITH(availExtensions,
    AS_HELP_STRING([--with-availExtensions=ans],[Allow extensions to be printed with avail. [[yes]]]),
    AVAIL_EXTENSIONS="$withval"
    AVAIL_EXTENSIONS=`echo $AVAIL_EXTENSIONS | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    VALID_YN $AVAIL_EXTENSIONS "--with-availExtensions=ans: ans must be yes or no"
    AC_MSG_RESULT([AVAIL_EXTENSIONS=$with_availExtensions])
    AC_DEFINE_UNQUOTED(AVAIL_EXTENSIONS, "$with_availExtensions")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([AVAIL_EXTENSIONS=$withval])
    AVAIL_EXTENSIONS="$withval"
    AC_DEFINE_UNQUOTED(AVAIL_EXTENSIONS, "$withval"))dnl

AC_SUBST(PATH_TO_LUA)
AC_ARG_WITH(lua,
    AS_HELP_STRING([--with-lua=ans],[absolute path to the lua interpreter to use [[lua]]]),
    PATH_TO_LUA="$withval"
    if test $(printf %.1s "$PATH_TO_LUA") != '/' ; then
      echo 
      echo "ERROR: Path to lua must be absolute!"
      exit 1
    fi
    AC_MSG_RESULT([PATH_TO_LUA=$with_lua])
    AC_DEFINE_UNQUOTED(PATH_TO_LUA, "$with_lua")dnl
    ,
    withval="lua"
    PATH_TO_LUA="$withval"
    AC_MSG_RESULT([PATH_TO_LUA=$withval])
    AC_DEFINE_UNQUOTED(PATH_TO_LUA, "$withval"))dnl

AC_SUBST(PATH_TO_LUAC)
AC_ARG_WITH(luac,
    AS_HELP_STRING([--with-luac=ans],[absolute path to the luac interpreter to use [[luac]]]),
    PATH_TO_LUAC="$withval"
    if test $(printf %.1s "$PATH_TO_LUAC") != '/' ; then
      echo 
      echo "ERROR: Path to luac must be absolute"
      exit 1
    fi
    AC_MSG_RESULT([PATH_TO_LUAC=$with_luac])
    AC_DEFINE_UNQUOTED(PATH_TO_LUAC, "$with_luac")dnl
    ,
    withval="luac"
    PATH_TO_LUAC="$withval"
    AC_MSG_RESULT([PATH_TO_LUAC=$withval])
    AC_DEFINE_UNQUOTED(PATH_TO_LUAC, "$withval"))dnl


AC_SUBST(LUA_SUFFIX)
AC_ARG_WITH(luaSuffix,
    AS_HELP_STRING([--with-luaSuffix=],[Specify a suffix for lua and luac[[no]]]),
    LUA_SUFFIX="$withval"
    LUA_SUFFIX=`echo $LUA_SUFFIX | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    AC_MSG_RESULT([LUA_SUFFIX=$with_luaSuffic])
    AC_DEFINE_UNQUOTED(LUA_SUFFIX, "$with_luaSuffix")dnl
    ,
    withval="no"
    LUA_SUFFIX="$withval"
    AC_MSG_RESULT([LUA_SUFFIX=$withval])
    AC_DEFINE_UNQUOTED(LUA_SUFFIX, "$withval"))dnl

if test "$ALLOW_TCL_MFILES" = no ; then
  FAST_TCL_INTERP=no
fi

AC_SUBST(PATH_TO_TCLSH)
AC_PATH_PROGS(PATH_TO_TCLSH, [tclsh9.0] [tclsh9] [tclsh], UNKNOWN_TCLSH)
if test "$PATH_TO_TCLSH" = "UNKNOWN_TCLSH" -a "$ALLOW_TCL_MFILES" = yes; then
  echo
  echo "The tclsh program must be in your path. Quitting!"
  echo
  rm -f makefile
  exit 1
fi

if test -z "$TCL_PKG_CONFIG_DIR" ; then
  TCL_PKG_CONFIG_DIR=`$SRCDIR/proj_mgmt/find_tcl_pc.sh $PATH_TO_TCLSH`
fi


if test "$FAST_TCL_INTERP" = yes ; then
   OS=$(uname -s)
   AC_PATH_PROG(pkgConfig, pkg-config, "UNKNOWN_PKG_CONFIG")
   if test -n "$TCL_INCLUDE" -a -n "$TCL_LIBS"; then
      echo "Using user defined TCL include and lib"
      echo "using TCL_INCLUDE: $TCL_INCLUDE"
      echo "using TCL_LIBS:    $TCL_LIBS"
   elif test -n "$TCL_PKG_CONFIG_DIR" ; then
      if test "$pkgConfig" = "UNKNOWN_PKG_CONFIG" ; then
         echo
         echo   'To use $TCL_PKG_CONFIG_DIR, you must have valid pkg-config in your path. Quitting!'
         echo   
         rm -f makefile
         exit 1
      fi   
      echo "Using TCL_PKG_CONFIG_DIR with pkg-config to find TCL include and lib"
      export PKG_CONFIG_PATH=$TCL_PKG_CONFIG_DIR
      TCL_INCLUDE=`$pkgConfig --cflags-only-I tcl 2> /dev/null`
      TCL_LIBS=`$pkgConfig --libs tcl`
      echo PKG_CONFIG_PATH: $PKG_CONFIG_PATH
      echo TCL_INCLUDE:     $TCL_INCLUDE
      echo TCL_LIBS:        $TCL_LIBS
   elif test "$OS" = Darwin ; then
      echo "Using Darwin xcrun to find TCL include and lib"
      DIR=$(xcrun --show-sdk-path)
      TCL_INCLUDE="-I${DIR}/usr/include"
   else
      echo "Looping over include paths to find TCL include (not lib)"
      for i in /usr/include /usr/include/tcl /usr/include/tcl9* /usr/include/tcl8*  ; do
         if test -f $i/tcl.h ; then
            TCL_INCLUDE="-I$i"
            break;
         fi
      done
   fi
	   
   if test -z "$TCL_INCLUDE" ; then
      if test "$pkgConfig" = "UNKNOWN_PKG_CONFIG" ; then
         echo
         echo   "You must have valid pkg-config in your path. Quitting!"
         echo   
         rm -f makefile
         exit 1
      fi   
      echo "Looping over tcl names to find TCL include and lib"
      for i in tcl tcl8.8 tcl8.7 tcl8.6 tcl8.5; do
          $pkgConfig --exists $i
          if test $? = 0; then
              TCL_INCLUDE=`PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 $pkgConfig --cflags-only-I $i 2> /dev/null`
              TCL_LIBS=`$pkgConfig --libs $i`
              break
          fi
      done
   fi

   CPPFLAGS="$TCL_INCLUDE"

   AC_CHECK_HEADER(tcl.h,
                   [AC_DEFINE([HAVE_TCL_H], 1, [Define to 1 if you have tcl.h])],[]) 

   if test "$ac_cv_header_tcl_h" != yes ; then
      rm -f makefile
      FOUND_ERROR=yes
      MSG="Unable to build Lmod without tcl.h.  Please install the tcl devel package or configure --with-fastTCLInterp=no to not require tcl.h.  You can also provide your own tcl installation.  Please set TCL_PKG_CONFIG_DIR to point to the directory containing tcl.pc. This is typically in <tcl-installation>/lib/pkgconfig.  Or specify TCL_INCLUDE and TCL_LIBS w/o TCL_PKG_CONFIG_DIR.  If you use TCL_INCLUDE and TCL_LIBS you must provide the -I for TCL_INCLUDE and the -L -l to TCL_LIBS.  The directories alone are not sufficient!"
      ERR_MSG="$ERR_MSG||$MSG"
      AC_MSG_NOTICE([$MSG])
   fi
   if test -z "$TCL_LIBS" ; then
     AC_SEARCH_LIBS(Tcl_CreateInterp, [tcl] [tcl8.8] [tcl8.7] [tcl8.6] [tcl8.5],[],
                  [rm -f makefile; AC_MSG_ERROR([Unable to build Lmod with -ltcl Please install the tcl devel package or configure --with-fastTCLInterp=no to not require the tcl library])], [$TCL_LIBS])

   fi
   AC_SUBST(TCL_INCLUDE, "$TCL_INCLUDE")
   AC_SUBST(TCL_LIBS, "$TCL_LIBS")
fi

AC_SUBST(SYS_LD_LIB_PATH)
SYS_LD_LIB_PATH=$LD_LIBRARY_PATH

AC_SUBST(SYS_LD_PRELOAD)
SYS_LD_PRELOAD=$LD_PRELOAD

AC_SUBST(PATH_TO_SRC)

##### UTILS -- start

AC_SUBST(BASENAME)
AC_SUBST(EXPR)
AC_SUBST(PATH_TO_POD2MAN)
AC_SUBST(PS)
AC_SUBST(READLINK)
AC_SUBST(PATH_TO_LS)
AC_SUBST(PATH_TO_GIT)
AC_SUBST(PATH_TO_HASHSUM)
AC_SUBST(PATH_TO_PAGER)

if test $MODE = "user_default" ; then
  mode=0755
  EXEC_BITS=$(( 0111 & $mode ));
  if test $EXEC_BITS = 0; then
MSG="MODE must have at least one executable bit set (Not MODE=$MODE)
Please try setting mode to 755 or 750 or 700 or similar."

     echo "$MSG"
     echo
ERR_MSG="$ERR_MSG
$MSG"
     rm -f makefile
     exit 1
  fi
fi


AC_PATH_PROG(PS,ps, UNKNOWN_PS)
if test "$PS" = "UNKNOWN_PS" ; then
  echo
  echo "You must have valid ps in your path. Quitting!"
  echo
  rm -f makefile
  exit 1
fi

AC_PATH_PROG(READLINK,readlink, UNKNOWN_READLINK)
if test "$READLINK" = "UNKNOWN_READLINK" ; then
  echo
  echo "You must have valid ps in your path. Quitting!"
  echo
  rm -f makefile
  exit 1
fi

AC_PATH_PROGS(EXPR,[gexpr] [expr], UNKNOWN_EXPR)
if test "$EXPR" = "UNKNOWN_EXPR" ; then
  echo
  echo "You must have valid expr or gexpr in your path. Quitting!"
  echo
  rm -f makefile
  exit 1
fi

AC_PATH_PROGS(BASENAME, [gbasename] [basename], UNKNOWN_BASENAME)
if test "$BASENAME" = "UNKNOWN_BASENAME" ; then
  echo
  echo "You must have either basename or gbasename in your path. Quitting!"
  echo
  rm -f makefile
  exit 1
fi

AC_PATH_PROGS(BC, [bc], UNKNOWN_BC)
if test "$BC" = "UNKNOWN_BC" ; then
  echo
  echo "You must have bc in your path. Quitting!"
  echo
  rm -f makefile
  exit 1
fi

AC_PATH_PROG(PATH_TO_POD2MAN, pod2man, UNKNOWN_POD2MAN)

AC_PATH_PROG(PATH_TO_GIT, git, "")
AC_PATH_PROGS(PATH_TO_PAGER,[less] [more], [more])

AC_PATH_PROGS(PATH_TO_HASHSUM, [sha1sum] [gsha1sum] [shasum] [md5sum] [gmd5sum] [md5], UNKNOWN_HASHSUM)
if test "`basename $PATH_TO_HASHSUM`" = "md5" ; then
  PATH_TO_HASHSUM="$PATH_TO_HASHSUM -r"
elif test "$PATH_TO_HASHSUM" = "UNKNOWN_HASHSUM" ; then
  echo
  echo "You must have either sha1sum, shasum, md5sum or md5 in your path. Quitting!"
  echo
  rm -f makefile
  exit 1
fi

AC_PATH_PROGS(PATH_TO_TR, [gtr] [tr],"")
AC_PATH_PROGS(PATH_TO_LS, [gls] [ls], "")

##### UTILS -- end

##### LUA configuration -- start

if ! (command -v $PATH_TO_LUA &>/dev/null) ; then
  echo 'The program "'$PATH_TO_LUA'" must be in your path'
  rm -f makefile
  exit 1
fi

if test "${LUA_SUFFIX}" != no ; then
   if test $(printf %.1s "$PATH_TO_LUA") = '/' -o $(printf %.1s "$PATH_TO_LUA") = '/'; then
      echo "Neither --with-lua= nor --with-luac= can be used with --with-luaSuffix="
      rm -f makefile
      exit 1
   fi
   PATH_TO_LUA=lua$LUA_SUFFIX
   PATH_TO_LUAC=luac$LUA_SUFFIX
   echo "1) PATH_TO_LUA: $PATH_TO_LUA"
else   
   mismatch=
   if test $(printf %.1s "$PATH_TO_LUA") = '/' -a $(printf %.1s "$PATH_TO_LUA") != '/'; then
      mismatch="true"
   fi
   if test $(printf %.1s "$PATH_TO_LUA") != '/' -a $(printf %.1s "$PATH_TO_LUA") = '/'; then
      mismatch="true"
   fi
   if test "$mismatch" = true ; then
      echo "Both --with-lua= and --with-luac= must both be specified"
      rm -f makefile
      exit 1
   fi   
fi

if ! (command -v $PATH_TO_LUA &>/dev/null) ; then
  echo 'The program "'$PATH_TO_LUA'" must be in your path'
  rm -f makefile
  exit 1
fi

if test $(printf %.1s "$PATH_TO_LUA") != '/' ; then
  AC_PATH_PROG(FIND_PATH_TO_LUA, $PATH_TO_LUA)
  PATH_TO_LUA=$(FOLLOW_READLINK $FIND_PATH_TO_LUA)
fi

if ! (command -v $PATH_TO_LUAC &>/dev/null) ; then
  echo 'The program "'$PATH_TO_LUAC'" must be in your path'
  rm -f makefile
  exit 1
fi

if test $(printf %.1s "$PATH_TO_LUA") != '/' ; then
  AC_PATH_PROG(FIND_PATH_TO_LUAC, $PATH_TO_LUAC)
  PATH_TO_LUAC=$(FOLLOW_READLINK $FIND_PATH_TO_LUAC)
fi

printf "checking for valid Lua version"

ORIG_LUA_PATH="$LUA_PATH"
export LUA_PATH="${SRCDIR}/src/?.lua;$LUA_PATH;;"
LuaV=$( $PATH_TO_LUA -e 'print(_VERSION)' | sed -e 's/Lua //' )
LmodV=$( $PATH_TO_LUA  -e "v=require('Version'); s=v.name():gsub(' .*','');print(s)")
if test -n "$PATH_TO_GIT" -a -e $ac_confdir/.git ; then
  lmodV=$($PATH_TO_GIT describe)
else
  lmodV=$($PATH_TO_LUA -e "v=require('Version'); s=v.git():gsub(' .*','');print(s)")
fi

IntLuaV=$( $PATH_TO_LUA  -e "_,_,M,m=_VERSION:gsub('Lua%s+',''):find('(%d+)%.(%d)'); print(math.floor(tonumber(M)*1000+tonumber(m)))")

if test $IntLuaV -lt 5001 -o $IntLuaV -gt 5005; then
  echo "Error: Lmod requires versions 5.1, 5.2, 5.3, 5.4, or 5.5 You have: $LuaV"
  rm -f makefile
  exit 1
fi

echo "... $LuaV"

if test -z "$ORIG_LUA_PATH" ; then
   unset LUA_PATH
else
   LUA_PATH="$ORIG_LUA_PATH"
fi

AC_SUBST(SYS_LUA_PATH)
AC_SUBST(SYS_LUA_CPATH)
SYS_LUA_PATH=$($PATH_TO_LUA -e "print(package.path)")
SYS_LUA_CPATH=$($PATH_TO_LUA -e "print(package.cpath)")
SYS_LUA_PATH=$(echo $SYS_LUA_PATH   | sed -e 's|^\./?.lua;||'       \
                                          -e 's|;\./?.lua;|;|'      \
                                          -e 's|;\./?.lua$||'       \
                                          -e 's|;\./?/init.lua;|;|' \
                                          -e 's|;\./?/init.lua$||'  )

SYS_LUA_CPATH=$(echo $SYS_LUA_CPATH | sed -e 's|^\./?.so;||'   \
                                          -e 's|;\./?.so;|;|'  \
                                          -e 's|;\./?.so$|;|')

printf "checking for lua modules: posix"

missingModules=""
for i in posix; do
  if ! ($PATH_TO_LUA $ac_confdir/proj_mgmt/luaModuleAvailable $i 2> /dev/null) ; then
    missingModules="$missingModules $i"
  fi
done

if test -n "$missingModules" ; then
  echo ""
  echo ""
  echo "Error: The follow lua module(s) are missing: $missingModules"
  echo ""
  echo "You can not run Lmod without: $missingModules"
  rm -f makefile
  exit 1
else
  echo "... yes"
fi

if test "$USE_BUILT_IN_PKGS" = yes ; then
  AC_SUBST(HAVE_LUAFILESYSTEM,no)
  AC_SUBST(HAVE_LUA_TERM,no)
else
  printf "checking for lua modules: lfs"

  missingModules=""
  for i in lfs; do
    if ! $PATH_TO_LUA $ac_confdir/proj_mgmt/luaModuleAvailable $i 2> /dev/null ; then
      missingModules="$i"
    fi
  done

  if test -n "$missingModules" ; then
    echo "... no"
  else
    lfsV=`$PATH_TO_LUA $ac_confdir/proj_mgmt/getLFSVersion`
    if test "$lfsV" -lt 1008000; then
       echo "... Too old, using providing version"
    else
       echo "... yes"    
       AC_SUBST(HAVE_LUAFILESYSTEM,yes)
    fi
  fi

  printf "checking for lua modules: term"

  missingModules=""
  for i in term; do
    if ! $PATH_TO_LUA $ac_confdir/proj_mgmt/luaModuleAvailable $i 2> /dev/null ; then
      missingModules="$missingModules $i"
    fi
  done

  if test -n "$missingModules" ; then
    echo "... no"
  else
    AC_SUBST(HAVE_LUA_TERM,yes)
    echo "... yes"
  fi
fi

WD=`pwd`

PATH_TO_LUA_DIR=$(dirname ${PATH_TO_LUA})

cd $PATH_TO_LUA_DIR/..

PATH_TO_LUA_DIR=`pwd`

cd $WD

if ! test -f $LUA_INCLUDE/lua.h; then
   LUA_INCLUDE=$PATH_TO_LUA_DIR/include
fi

if ! test -f $LUA_INCLUDE/lua.h; then
  AC_PATH_PROG(pkgConfig, pkg-config, "")
  if  ! test x$pkgConfig = "x"; then
    for i in lua$LuaV lua; do
      PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 $pkgConfig --exists $i
      if test $? = 0; then
        LUA_INCLUDE=`PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 $pkgConfig --cflags-only-I $i 2> /dev/null | sed -e 's/^-I//' -e 's/ //g'`
        break
      fi
    done
  fi
fi

if ! test -f $LUA_INCLUDE/lua.h; then
  for i in /usr/include/lua$LuaV /usr/include/lua /usr/include; do
     if test -f $i/lua.h ; then
        LUA_INCLUDE=$i
        break
     fi
  done
fi

if ! test "$HAVE_LUA_TERM" = yes; then
  if ! test -f $LUA_INCLUDE/lua.h; then
    echo
    echo Error can not find lua.h which is needed to build lua-term.
    echo You can either install lua-term or the lua development package.
    echo Quitting!
    echo
    rm -f makefile
    exit 1
  fi
fi

##### LUA configuration -- end

if test "$FOUND_ERROR" = yes; then
  echo
  echo One or more errors found:
  echo
  echo Error Messages:
  echo "------------------------------------------------------------"
  echo $ERR_MSG | tr '|' '\n' | while read item; do
       echo $item
  done   
  echo "------------------------------------------------------------"
  
  rm -f makefile
  exit 1;
fi      

AC_SUBST(ZSH_SITE_FUNCTIONS_DIRS)
AC_PATH_PROG(ZSH, zsh)
PATH_TO_ZSH=$ZSH

if test -n "$PATH_TO_ZSH" ; then
  cat > conftest.zsh << 'EOF'
  resultA=()
  for dir in $fpath ; do
    case $dir in
      */site-functions)
        if test -d $dir ; then
          resultA+=($dir)
          break
        fi
        ;;
    esac
  done
  if test "$#resultA" = 0; then
     echo "/dev/null"
  else
     result=$(printf "%s:" "${resultA@<:@@@:>@}") # convert array to colon separated string
     result=$result@<:@1,-2@:>@                   # remove trailing colon
     echo $result
  fi
EOF

   chmod +x conftest.zsh

   unset FPATH
   ZSH_SITE_FUNCTIONS_DIRS=`$PATH_TO_ZSH -f ./conftest.zsh 2> /dev/null`

   rm conftest.zsh
fi

AC_SUBST(ORIG_ZSH_VERSION)
if test -n "$PATH_TO_ZSH" ; then
   cat > conftest.zsh << 'EOF'
echo $ZSH_VERSION
EOF
   chmod +x conftest.zsh
   ORIG_ZSH_VERSION=`$PATH_TO_ZSH -f ./conftest.zsh 2> /dev/null`
   rm conftest.zsh
fi


AC_SUBST(ZSH_FPATH)
if test -n "$PATH_TO_ZSH" ; then
  cat > conftest.zsh << 'EOF'
echo $FPATH
EOF

   chmod +x conftest.zsh

   unset FPATH
   ZSH_FPATH=`$PATH_TO_ZSH -f ./conftest.zsh 2> /dev/null`

   rm conftest.zsh
fi



AC_CONFIG_FILES([makefile:Makefile.in])
AC_OUTPUT

AX_SUMMARIZE_CONFIG

dnl Process this file with autoconf to produce a configure script.
dnl This is for lmod


AC_INIT(Makefile.in)
AC_PREFIX_DEFAULT(/usr/local)
AC_PROG_CC


AC_SUBST(DUPLICATE_PATHS)
AC_ARG_WITH(duplicatePaths,
    AC_HELP_STRING([--with-duplicatePaths=ans],[Allow duplicate directories in path like variables [[no]]]),
    DUPLICATE_PATHS="$withval"
    AC_MSG_RESULT([DUPLICATE_PATHS=$with_duplicatePaths])
    AC_DEFINE_UNQUOTED(DUPLICATE_PATHS,"$with_duplicatePaths")dnl
    ,
    withval="no"
    AC_MSG_RESULT([DUPLICATE_PATHS=$withval])
    DUPLICATE_PATHS="$withval"
    AC_DEFINE_UNQUOTED(DUPLICATE_PATHS, "$withval"))dnl

AC_SUBST(SITE_MSG_FILE)
AC_ARG_WITH(siteMsgFile,
    AC_HELP_STRING([--with-siteMsgFile=ans],[Site Message File [[<empty>]]]),
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
    AC_HELP_STRING([--with-lang=ans],[Override $LANG for Lmod errors/messsages/warnings [[<empty>]]]),
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
    AC_HELP_STRING([--with-caseIndependentSorting=ans],[Make avail and spider use case independent sorting [[no]]]),
    CASE_INDEPENDENT_SORTING="$withval"
    AC_MSG_RESULT([CASE_INDEPENDENT_SORTING=$with_caseIndependentSorting])
    AC_DEFINE_UNQUOTED(CASE_INDEPENDENT_SORTING,"$with_caseIndependentSorting")dnl
    ,
    withval="no"
    AC_MSG_RESULT([CASE_INDEPENDENT_SORTING=$withval])
    CASE_INDEPENDENT_SORTING="$withval"
    AC_DEFINE_UNQUOTED(CASE_INDEPENDENT_SORTING, "$withval"))dnl

AC_SUBST(COLORIZE)
AC_ARG_WITH(colorize,
    AC_HELP_STRING([--with-colorize=ans],[allow for colorized output [[yes]]]),
    COLORIZE="$withval"
    AC_MSG_RESULT([COLORIZE=$with_colorize])
    AC_DEFINE_UNQUOTED(COLORIZE, "$with_colorize")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([COLORIZE=$withval])
    COLORIZE="$withval"
    AC_DEFINE_UNQUOTED(COLORIZE, "$withval"))dnl

AC_SUBST(HIDDEN_ITALIC)
AC_ARG_WITH(hiddenItalic,
    AC_HELP_STRING([--with-hiddenItalic=ans],[Use italic for hidden module instead of faint[[no]]]),
    HIDDEN_ITALIC="$withval"
    AC_MSG_RESULT([HIDDEN_ITALIC=$with_hiddenItalic])
    AC_DEFINE_UNQUOTED(HIDDEN_ITALIC, "$with_hiddenItalic")dnl
    ,
    withval="no"
    AC_MSG_RESULT([HIDDEN_ITALIC=$withval])
    HIDDEN_ITALIC="$withval"
    AC_DEFINE_UNQUOTED(HIDDEN_ITALIC, "$withval"))dnl

AC_SUBST(EXACT_MATCH)
AC_ARG_WITH(exactMatch,
    AC_HELP_STRING([--with-exactMatch=ans],[require exact match, disable defaults [[no]]]),
    EXACT_MATCH="$withval"
    AC_MSG_RESULT([EXACT_MATCH=$with_exactMatch])
    AC_DEFINE_UNQUOTED(EXACT_MATCH, "$with_exactMatch")dnl
    ,
    withval="no"
    AC_MSG_RESULT([EXACT_MATCH=$withval])
    EXACT_MATCH="$withval"
    AC_DEFINE_UNQUOTED(EXACT_MATCH, "$withval"))dnl

AC_SUBST(AUTO_SWAP)
AC_ARG_WITH(autoSwap,
    AC_HELP_STRING([--with-autoSwap=ans],[Allow auto swapping of compiler etc. [[yes]]]),
    AUTO_SWAP="$withval"
    AC_MSG_RESULT([AUTO_SWAP=$with_autoSwap])
    AC_DEFINE_UNQUOTED(AUTO_SWAP, "$with_autoSwap")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([AUTO_SWAP=$withval])
    AUTO_SWAP="$withval"
    AC_DEFINE_UNQUOTED(AUTO_SWAP, "$withval"))dnl

AC_SUBST(EXPORT_MODULE)
AC_ARG_WITH(exportedModuleCmd,
    AC_HELP_STRING([--with-exportedModuleCmd=ans],[Export the module command. [[yes]]]),
    with_exportedModuleCmd=`echo $with_exportedModuleCmd | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    withval=$with_exportedModuleCmd
    EXPORT_MODULE="$withval"
    AC_MSG_RESULT([EXPORT_MODULE=$with_exportedModuleCmd])
    AC_DEFINE_UNQUOTED(EXPORT_MODULE, "$with_exportedModuleCmd")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([EXPORT_MODULE=$withval])
    EXPORT_MODULE="$withval"
    AC_DEFINE_UNQUOTED(EXPORT_MODULE, "$withval"))dnl

AC_SUBST(REDIRECT)
AC_ARG_WITH(redirect,
    AC_HELP_STRING([--with-redirect=ans],[redirect messages to stdout [[no]]]),
    REDIRECT="$withval"
    AC_MSG_RESULT([REDIRECT=$with_redirect])
    AC_DEFINE_UNQUOTED(REDIRECT, "$with_redirect")dnl
    ,
    withval="no"
    AC_MSG_RESULT([REDIRECT=$withval])
    REDIRECT="$withval"
    AC_DEFINE_UNQUOTED(REDIRECT, "$withval"))dnl

AC_SUBST(MODULEPATH_ROOT)dnl
AC_ARG_WITH(module-root-path,
    AC_HELP_STRING([--with-module-root-path=<path>],[use module root path=<path> [[PREFIX/modulefiles]]]),
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
    AC_HELP_STRING([--with-ancient=num_secs],[How long to wait before rebuilding spider cache file=num_secs [[86400]]]),
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
    AC_HELP_STRING([--with-shortTime=seconds],[if spider build time < shortTime then no spider cache file [[2]]]),
    SHORT_TIME="$withval"
    AC_MSG_RESULT([SHORT_TIME=$with_shortTime])
    AC_DEFINE_UNQUOTED(SHORT_TIME, "$with_shortTime")dnl
    ,
    withval="2"
    AC_MSG_RESULT([SHORT_TIME=$withval])
    SHORT_TIME="$withval"
    AC_DEFINE_UNQUOTED(SHORT_TIME, "$withval"))dnl

AC_SUBST(USE_DOT_FILES)
AC_ARG_WITH(useDotFiles,
    AC_HELP_STRING([--with-useDotFiles=yes/no],[If yes use ~/.lmod.d/.cache, if no use ~/.lmod.d/__cache__]),
    USE_DOT_FILES="$withval"
    AC_MSG_RESULT([USE_DOT_FILES=$with_useDotFiles])
    AC_DEFINE_UNQUOTED(USE_DOT_FILES, "$with_useDotFiles")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([USE_DOT_FILES=$withval])
    USE_DOT_FILES="$withval"
    AC_DEFINE_UNQUOTED(USE_DOT_FILES, "$withval"))dnl

AC_SUBST(SPIDER_CACHE_DIRS)
AC_ARG_WITH(spiderCacheDir,
    AC_HELP_STRING([--with-spiderCacheDir=dir1:dir2],[use these directories to hold a spider cache file [[]]]),
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
    AC_HELP_STRING([--with-spiderCacheDescript=fn],[Use specified file to describe cache directory and timestamp files [[]]]),
    SPIDER_CACHE_DESCRIPT_FN="$withval"
    AC_MSG_RESULT([SPIDER_CACHE_DESCRIPT_FN=$with_spiderCacheDescript])
    AC_DEFINE_UNQUOTED(SHORT_TIME, "$with_spiderCacheDescript")dnl
    ,
    withval=""
    AC_MSG_RESULT([SPIDER_CACHE_DESCRIPT_FN=$withval])
    SPIDER_CACHE_DESCRIPT_FN="$withval"
    AC_DEFINE_UNQUOTED(SPIDER_CACHE_DESCRIPT_FN, "$withval"))dnl

AC_SUBST(UPDATE_SYSTEM_FN)
AC_ARG_WITH(updateSystemFn,
    AC_HELP_STRING([--with-updateSystemFn=file],[This file is touched when the system has been updated [[]]]),
    UPDATE_SYSTEM_FN="$withval"
    AC_MSG_RESULT([UPDATE_SYSTEM_FN=$with_updateSystemFn])
    AC_DEFINE_UNQUOTED(SHORT_TIME, "$with_updateSystemFn")dnl
    ,
    withval=""
    AC_MSG_RESULT([UPDATE_SYSTEM_FN=$withval])
    UPDATE_SYSTEM_FN="$withval"
    AC_DEFINE_UNQUOTED(UPDATE_SYSTEM_FN, "$withval"))dnl

AC_SUBST(PREPEND_BLOCK)
AC_ARG_WITH(prependBlock,
    AC_HELP_STRING([--with-prependBlock=ans],[Treat multiple directories passed to prepend in normal order/ not reversed [[NORMAL]]]),
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
    AC_HELP_STRING([--with-siteName=ans],[Site Name [[<empty>]]]),
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
    AC_HELP_STRING([--with-syshost=ans],[Site Name [[<empty>]]]),
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
    AC_HELP_STRING([--with-tcl=ans],[Allow TCL modulefiles [[yes]]]),
    ALLOW_TCL_MFILES="$withval"
    AC_MSG_RESULT([ALLOW_TCL_MFILES==$withval])
    AC_DEFINE_UNQUOTED(ALLOW_TCL_MFILES, "$withval")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([ALLOW_TCL_MFILES=$withval])
    ALLOW_TCL_MFILES="$withval"
    AC_DEFINE_UNQUOTED(ALLOW_TCL_MFILES, "$withval"))dnl

AC_SUBST(DISABLE_NAME_AUTOSWAP)
AC_ARG_WITH(disableNameAutoSwap,
    AC_HELP_STRING([--with-disableNameAutoSwap=ans],[disable one name rule autoswapping [[no]]]),
    DISABLE_NAME_AUTOSWAP="$withval"
    AC_MSG_RESULT([DISABLE_NAME_AUTOSWAP==$withval])
    AC_DEFINE_UNQUOTED(DISABLE_NAME_AUTOSWAP, "$withval")dnl
    ,
    withval="no"
    AC_MSG_RESULT([DISABLE_NAME_AUTOSWAP=$withval])
    DISABLE_NAME_AUTOSWAP="$withval"
    AC_DEFINE_UNQUOTED(DISABLE_NAME_AUTOSWAP, "$withval"))dnl

AC_SUBST(MPATH_AVAIL)
AC_ARG_WITH(mpathSearch,
    AC_HELP_STRING([--with-mpathSearch=ans],[include modulepath directory name in avail searching [[no]]]),
    MPATH_AVAIL="$withval"
    AC_MSG_RESULT([MPATH_AVAIL==$withval])
    AC_DEFINE_UNQUOTED(MPATH_AVAIL, "$withval")dnl
    ,
    withval="no"
    AC_MSG_RESULT([MPATH_AVAIL=$withval])
    MPATH_AVAIL="$withval"
    AC_DEFINE_UNQUOTED(MPATH_AVAIL, "$withval"))dnl

AC_SUBST(SETTARG)
AC_ARG_WITH(settarg,
    AC_HELP_STRING([--with-settarg=ans],[startup files fully support settarg [[no]]]),
    SETTARG="$withval"
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
    AC_HELP_STRING([--with-ignoreDirs=ans],[list of directories to ignore [[.svn,.git,.hg,.bzr]]]),
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
    AC_HELP_STRING([--with-pinVersions=ans],[Save/Restore will use the current version instead of changing with the default.[[no]]]),
    PIN_VERSIONS="$withval"
    AC_MSG_RESULT([PIN_VERSIONS=$with_pinVersions])
    AC_DEFINE_UNQUOTED(PIN_VERSIONS, "$with_pinVersions")dnl
    ,
    withval="NO"
    AC_MSG_RESULT([PIN_VERSIONS=$withval])
    PIN_VERSIONS="$withval"
    AC_DEFINE_UNQUOTED(PIN_VERSIONS, "$withval"))dnl

AC_SUBST(TMOD_PATH_RULE)
AC_ARG_WITH(tmodPathRule,
    AC_HELP_STRING([--with-tmodPathRule=ans],[If path entry is already there then do not append/prepend.[[no]]]),
    TMOD_PATH_RULE="$withval"
    AC_MSG_RESULT([TMOD_PATH_RULE=$with_tmodPathRule])
    AC_DEFINE_UNQUOTED(TMOD_PATH_RULE, "$with_tmodPathRule")dnl
    ,
    withval="NO"
    AC_MSG_RESULT([TMOD_PATH_RULE=$withval])
    TMOD_PATH_RULE="$withval"
    AC_DEFINE_UNQUOTED(TMOD_PATH_RULE, "$withval"))dnl

AC_SUBST(TMOD_FIND_FIRST)
AC_ARG_WITH(tmodFindFirst,
    AC_HELP_STRING([--with-tmodFindFirst=ans],[Use Tmod Find First rule instead of Find Best for defaults.[[no]]]),
    TMOD_FIND_FIRST="$withval"
    AC_MSG_RESULT([TMOD_FIND_FIRST=$with_tmodFindFirst])
    AC_DEFINE_UNQUOTED(TMOD_FIND_FIRST, "$with_tmodFindFirst")dnl
    ,
    withval="NO"
    AC_MSG_RESULT([TMOD_FIND_FIRST=$withval])
    TMOD_FIND_FIRST="$withval"
    AC_DEFINE_UNQUOTED(TMOD_FIND_FIRST, "$withval"))dnl

AC_SUBST(LUA_INCLUDE)
AC_ARG_WITH(lua_include,
    AC_HELP_STRING([--with-lua_include=ans],[Save/Restore will use the current version instead of changing with the default.[[no]]]),
    LUA_INCLUDE="$withval"
    AC_MSG_RESULT([LUA_INCLUDE=$with_lua_include])
    AC_DEFINE_UNQUOTED(LUA_INCLUDE, "$with_lua_include")dnl
    ,
    withval="NO"
    AC_MSG_RESULT([LUA_INCLUDE=$withval])
    LUA_INCLUDE="$withval"
    AC_DEFINE_UNQUOTED(LUA_INCLUDE, "$withval"))dnl

AC_SUBST(CACHED_LOADS)
AC_ARG_WITH(cachedLoads,
    AC_HELP_STRING([--with-cachedLoads=ans],[Use cache when loading modules. [[no]]]),
    CACHED_LOADS="$withval"
    AC_MSG_RESULT([CACHED_LOADS=$with_cachedLoads])
    AC_DEFINE_UNQUOTED(CACHED_LOADS, "$with_cachedLoads")dnl
    ,
    withval="NO"
    AC_MSG_RESULT([CACHED_LOADS=$withval])
    CACHED_LOADS="$withval"
    AC_DEFINE_UNQUOTED(CACHED_LOADS, "$withval"))dnl

AC_SUBST(EXTENDED_DEFAULT)
AC_ARG_WITH(extendedDefault,
    AC_HELP_STRING([--with-extendedDefault=ans],[Allow for extended default. [[yes]]]),
    EXTENDED_DEFAULT="$withval"
    AC_MSG_RESULT([EXTENDED_DEFAULT=$with_extendedDefault])
    AC_DEFINE_UNQUOTED(EXTENDED_DEFAULT, "$with_extendedDefault")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([EXTENDED_DEFAULT=$withval])
    EXTENDED_DEFAULT="$withval"
    AC_DEFINE_UNQUOTED(EXTENDED_DEFAULT, "$withval"))dnl

AC_SUBST(MODULEPATH_INIT)
AC_ARG_WITH(ModulePathInit,
    AC_HELP_STRING([--with-ModulePathInit=ans],[File containing initial MODULEPATH directories]),
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
    AC_HELP_STRING([--with-siteControlPrefix=ans],[A user controlled prefix. [[no]]]),
    SITE_CONTROLLED_PREFIX="$withval"
    AC_MSG_RESULT([SITE_CONTROLLED_PREFIX=$with_siteControlPrefix])
    AC_DEFINE_UNQUOTED(SITE_CONTROLLED_PREFIX, "$with_siteControlPrefix")dnl
    ,
    withval="no"
    AC_MSG_RESULT([SITE_CONTROLLED_PREFIX=$withval])
    SITE_CONTROLLED_PREFIX="$withval"
    AC_DEFINE_UNQUOTED(SITE_CONTROLLED_PREFIX, "$withval"))dnl

AC_SUBST(USE_BUILT_IN_PKGS)
AC_ARG_WITH(useBuiltinPkgs,
    AC_HELP_STRING([--with-useBuiltinPkgs=ans],[Use Built-in lua package instead of system ones. [[no]]]),
    USE_BUILT_IN_PKGS="$withval"
    AC_MSG_RESULT([USE_BUILT_IN_PKGS=$with_useBuiltinPkgs])
    AC_DEFINE_UNQUOTED(USE_BUILT_IN_PKGS, "$with_useBuiltinPkgs")dnl
    ,
    withval="no"
    AC_MSG_RESULT([USE_BUILT_IN_PKGS=$withval])
    USE_BUILT_IN_PKGS="$withval"
    AC_DEFINE_UNQUOTED(USE_BUILT_IN_PKGS, "$withval"))dnl

AC_SUBST(SILENCE_SHELL_DEBUGGING)
AC_ARG_WITH(silentShellDebugging,
    AC_HELP_STRING([--with-silentShellDebugging=ans],[Use Built-in lua package instead of system ones. [[no]]]),
    SILENCE_SHELL_DEBUGGING="$withval"
    AC_MSG_RESULT([SILENCE_SHELL_DEBUGGING=$with_silentShellDebugging])
    AC_DEFINE_UNQUOTED(SILENCE_SHELL_DEBUGGING, "$with_silentShellDebugging")dnl
    ,
    withval="no"
    AC_MSG_RESULT([SILENCE_SHELL_DEBUGGING=$withval])
    SILENCE_SHELL_DEBUGGING="$withval"
    AC_DEFINE_UNQUOTED(SILENCE_SHELL_DEBUGGING, "$withval"))dnl

AC_SUBST(FAST_TCL_INTERP)
AC_ARG_WITH(fastTCLInterp,
    AC_HELP_STRING([--with-fastTCLInterp=ans],[Use the fast TCL interpreter. [[yes]]]),
    FAST_TCL_INTERP="$withval"
    FAST_TCL_INTERP=`echo $FAST_TCL_INTERP | tr '@<:@:upper:@:>@' '@<:@:lower:@:>@'`
    AC_MSG_RESULT([FAST_TCL_INTERP=$with_fastTCLInterp])
    AC_DEFINE_UNQUOTED(FAST_TCL_INTERP, "$with_fastTCLInterp")dnl
    ,
    withval="yes"
    AC_MSG_RESULT([FAST_TCL_INTERP=$withval])
    FAST_TCL_INTERP="$withval"
    AC_DEFINE_UNQUOTED(FAST_TCL_INTERP, "$withval"))dnl


if test "$ALLOW_TCL_MFILES" = no ; then
  FAST_TCL_INTERP=no
fi

Broken_FAST_TCL_INTERP=yes
if test "$FAST_TCL_INTERP" = no ; then
   Broken_FAST_TCL_INTERP=no
fi
  

if test "$FAST_TCL_INTERP" = yes ; then
   Broken_FAST_TCL_INTERP=no
   OS=$(uname -s)
   DIR=/usr/include/tcl
   if test "$OS" = Darwin ; then
     DIR=$(xcrun --show-sdk-path)
     DIR=${DIR}/usr/include
   fi


   CPPFLAGS="-I $DIR"

   AC_CHECK_HEADER(tcl.h,
                   [AC_DEFINE([HAVE_TCL_H], 1, [Define to 1 if you have tcl.h])],[]) 

   if test "$ac_cv_header_tcl_h" != yes ; then
      rm -f makefile
      AC_MSG_ERROR([Unable to build Lmod without tcl.h.  Please install the tcl devel package or configure --with-fastTCLInterp=no to not require tcl.h])
   fi
   AC_SEARCH_LIBS(Tcl_CreateInterp,[tcl] [tcl8.8] [tcl8.7] [tcl8.6] [tcl8.5],[],
                [rm -f makefile; AC_MSG_ERROR([Unable to build Lmod with -ltcl Please install the tcl devel package or configure --with-fastTCLInterp=no to not require the tcl library])])
fi

if test "$Broken_FAST_TCL_INTERP" = yes ; then
  echo
  echo "the option --with-fastTCLInterp takes either a yes or a no. Quitting!"
  echo
  rm -f makefile
  exit
fi


AC_SUBST(SYS_LD_LIB_PATH)
SYS_LD_LIB_PATH=$LD_LIBRARY_PATH

AC_SUBST(SYS_LD_PRELOAD)
SYS_LD_PRELOAD=$LD_PRELOAD

AC_SUBST(BASENAME)
AC_SUBST(EXPR)
AC_SUBST(PS)
AC_SUBST(PATH_TO_LS)
AC_SUBST(PATH_TO_GIT)
AC_SUBST(PATH_TO_HASHSUM)
AC_SUBST(PATH_TO_LUA)
AC_SUBST(PATH_TO_LUAC)
AC_SUBST(PATH_TO_PAGER)
AC_SUBST(PATH_TO_SRC)
AC_SUBST(PATH_TO_TCLSH)

AC_PATH_PROG(PS,ps, UNKNOWN_PS)
if test "$PS" = "UNKNOWN_PS" ; then
  echo
  echo "You must have valid ps in your path. Quitting!"
  echo
  rm -f makefile
  exit
fi

AC_PATH_PROGS(EXPR,[gexpr] [expr], UNKNOWN_EXPR)
if test "$EXPR" = "UNKNOWN_EXPR" ; then
  echo
  echo "You must have valid expr or gexpr in your path. Quitting!"
  echo
  rm -f makefile
  exit
fi

AC_PATH_PROGS(BASENAME, [gbasename] [basename], UNKNOWN_BASENAME)
if test "$BASENAME" = "UNKNOWN_BASENAME" ; then
  echo
  echo "You must have either basename in your path. Quitting!"
  echo
  rm -f makefile
  exit
fi





AC_PATH_PROGS(PATH_TO_LS, [gls] [ls], "")
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
  exit
fi

AC_PATH_PROG(PATH_TO_TCLSH, tclsh, UNKNOWN_TCLSH)
if test "$PATH_TO_TCLSH" = "UNKNOWN_TCLSH" -a "$ALLOW_TCL_MFILES" = yes; then
  echo
  echo "The tclsh program must be in your path. Quitting!"
  echo
  rm -f makefile
  exit
fi
AC_PATH_PROGS(PATH_TO_TR, [gtr] [tr],"")

AC_PATH_PROG(PATH_TO_LUAC, [luac])
AC_PATH_PROG(luaprog, [lua], "")

if test x$luaprog = "x"; then
  echo The program "lua" must be in your path
  rm -f makefile
  exit
fi

if test x$PATH_TO_LUAC = "x"; then
  echo The program "luac" must be in your path
  rm -f makefile
  exit
fi




oldprog=$luaprog
while test -L $luaprog; do
  luaprog=$(readlink $luaprog)
  if test ${luaprog:0:1} != '/' ; then
     d=`dirname $oldprog`
     luaprog="$d/$luaprog"
     CWD=`pwd`
     d=`dirname $luaprog`
     b=`basename $luaprog`
     cd $d
     d=`pwd`
     luaprog="$d/$b"
     cd $CWD
  fi
  oldprog=$luaprog
done


printf "checking for valid Lua version"

SRCDIR=$( cd $srcdir; pwd)
PATH_TO_SRC=$SRCDIR

ORIG_LUA_PATH="$LUA_PATH"
export LUA_PATH="${SRCDIR}/src/?.lua;$LUA_PATH;;"
LuaV=$( $luaprog -e 'print(_VERSION)' | sed -e 's/Lua //' )
LmodV=$( $luaprog  -e "v=require('Version'); s=v.name():gsub(' .*','');print(s)")
if test -n "$PATH_TO_GIT" -a -d .git ; then
  lmodV=$($PATH_TO_GIT describe)
else
  lmodV=$($luaprog -e "v=require('Version'); s=v.git():gsub(' .*','');print(s)")
fi

IntLuaV=$( $luaprog  -e "_,_,M,m=_VERSION:gsub('Lua%s+',''):find('(%d+)%.(%d)'); print(math.floor(tonumber(M)*1000+tonumber(m)))")

if test $IntLuaV -lt 5001 -o $IntLuaV -gt 5003; then
  echo "Error: Lmod requires versions 5.1 or 5.2 or 5.3, You have: $LuaV"
  rm -f makefile
  exit 1
fi

echo "... $LuaV"

PATH_TO_LUA=$(dirname $luaprog)

if test -z "$ORIG_LUA_PATH" ; then
   unset LUA_PATH
else
   LUA_PATH="$ORIG_LUA_PATH"
fi

AC_SUBST(SYS_LUA_PATH)
AC_SUBST(SYS_LUA_CPATH)
SYS_LUA_PATH=$($luaprog -e "print(package.path)")
SYS_LUA_CPATH=$($luaprog -e "print(package.cpath)")
SYS_LUA_PATH=$(echo $SYS_LUA_PATH   | sed -e 's|^\./?.lua;||'       \
                                          -e 's|;\./?.lua;|;|'      \
                                          -e 's|;\./?.lua$||'       \
                                          -e 's|;\./?/init.lua;|;|' \
                                          -e 's|;\./?/init.lua$||'  )

SYS_LUA_CPATH=$(echo $SYS_LUA_CPATH | sed -e 's|^\./?.so;||'   \
                                          -e 's|;\./?.so;|;|'  \
                                          -e 's|;\./?.so$|;|')

WD=`pwd`

PATH_TO_LUA_DIR=${PATH_TO_LUA}/..

cd $PATH_TO_LUA_DIR

PATH_TO_LUA_DIR=`pwd`

cd $WD

cat > luaModuleAvailable << 'EOF'
function main()
   for i = 1, #arg do
      require(arg[[i]])
      if (not package.loaded[[arg[i]]]) then
         print (arg[[i]], "not available")
      end
   end
end

main()
EOF

printf "checking for lua modules: posix"

missingModules=""
for i in posix; do
  $luaprog luaModuleAvailable $i 2> /dev/null
  if test "$?" != 0 ; then
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


cat > getLFSVersion << 'EOF'
local lfs       = require("lfs")

function string.split(self, pat)
   pat  = pat or "%s+"
   local st, g = 1, self:gmatch("()("..pat..")")
   local function getter(self, segs, seps, sep, cap1, ...)
      st = sep and seps + #sep
      return self:sub(segs, (seps or 0) - 1), cap1 or sep, ...
   end
   local function splitter(self)
      if st then return getter(self, st, g()) end
   end
   return splitter, self
end

function main()

   local version = lfs._VERSION:lower():gsub("luafilesystem  *","")
   local factorA = { 1000000, 1000, 1}

   local idx = 0
   local num = 0
   for s in version:split("%.") do
      local i,j = s:find("%d+")
      s         = s:sub(i,j)
      idx = idx + 1
      num = (tonumber(s) or 0)*factorA@<:@idx@:>@ + num
      if (idx >= #factorA) then break end
   end
   print(num)
end

main()
EOF

if test "$USE_BUILT_IN_PKGS" = yes ; then
  AC_SUBST(HAVE_LUAFILESYSTEM,no)
  AC_SUBST(HAVE_LUA_TERM,no)
else
  printf "checking for lua modules: lfs"

  missingModules=""
  for i in lfs; do
    $luaprog luaModuleAvailable $i 2> /dev/null
    if test "$?" != 0 ; then
      missingModules="$i"
    fi
  done

  if test -n "$missingModules" ; then
    echo "... no"
  else
    lfsV=`$luaprog getLFSVersion`
    if test "$lfsV" -lt 1006002; then
       echo "... Too old, using providing version"
    else
       echo "... yes"    
       AC_SUBST(HAVE_LUAFILESYSTEM,yes)
    fi
  fi


  printf "checking for lua modules: term"

  missingModules=""
  for i in term; do
    $luaprog luaModuleAvailable $i 2> /dev/null
    if test "$?" != 0 ; then
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


rm luaModuleAvailable getLFSVersion

if ! test -f $LUA_INCLUDE/lua.h; then
   LUA_INCLUDE=$PATH_TO_LUA_DIR/include
fi

if ! test -f $LUA_INCLUDE/lua.h; then
  AC_PATH_PROG(pkgConfig, pkg-config, "")
  if  ! test x$pkgConfig = "x"; then
    for i in lua$LuaV lua; do
      $pkgConfig --exists $i
      if test $? = 0; then
        LUA_INCLUDE=`$pkgConfig --cflags $i | sed -e 's/^-I//' -e 's/ //g'`
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

   ZSH_SITE_FUNCTIONS_DIRS=`$PATH_TO_ZSH -f ./conftest.zsh 2> /dev/null`

   rm conftest.zsh
fi

AC_OUTPUT(makefile:Makefile.in)

AX_SUMMARIZE_CONFIG

dnl ######################################################################
dnl $Id: configure.ac 419 2009-02-17 16:18:58Z mclay $
dnl ######################################################################
dnl Process this file with autoconf to produce a configure script.
dnl This is for MGF

AC_INIT(Makefile.in)
AC_PREFIX_DEFAULT(/usr/local)
AC_SUBST(MODULEPATH_ROOT)dnl
AC_ARG_WITH(module-root-path,
    AC_HELP_STRING([--with-module-root-path=<path>],[use module root path=<path> [[PREFIX/modulefiles]]]),
    MODULEPATH_ROOT="$withval"
    AC_MSG_RESULT([MODULEPATH_ROOT = $with_module_root_path])
    AC_DEFINE_UNQUOTED(MODULEPATH_ROOT, "$with_module_root_path")dnl
    ,
    withval="$prefix/modulefiles"
    AC_MSG_RESULT([MODULEPATH_ROOT=$withval])
    MODULEPATH_ROOT="$withval"
    AC_DEFINE_UNQUOTED(MODULEPATH_ROOT, "$withval"))dnl

AC_SUBST(PATH_TO_LUA)
AC_SUBST(PATH_TO_HASHSUM)
AC_PATH_PROGS(PATH_TO_HASHSUM, [sha1sum] [md5sum], "")
AC_PATH_PROG(luaprog, lua, "")
if test x$luaprog = "x"; then
  echo The program "lua" must be in your path
  exit
fi
PATH_TO_LUA=$(echo $luaprog | sed -e 's|/lua$||')


AC_OUTPUT(makefile:Makefile.in)


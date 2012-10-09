dnl Process this file with autoconf to produce a configure script.
dnl This is for lmod

AC_INIT(Makefile.in)
AC_PREFIX_DEFAULT(/usr/local)
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

AC_SUBST(SPIDER_CACHE_DIR)
AC_ARG_WITH(spiderCacheDir,
    AC_HELP_STRING([--with-spiderCacheDir=dir],[use this directory to hold a spider cache file [[]]]),
    SPIDER_CACHE_DIR="$withval"
    AC_MSG_RESULT([SPIDER_CACHE_DIR=$with_spiderCacheDir])
    AC_DEFINE_UNQUOTED(SHORT_TIME, "$with_spiderCacheDir")dnl
    ,
    withval=""
    AC_MSG_RESULT([SPIDER_CACHE_DIR=$withval])
    SPIDER_CACHE_DIR="$withval"
    AC_DEFINE_UNQUOTED(SPIDER_CACHE_DIR, "$withval"))dnl

AC_SUBST(PATH_TO_PAGER)
AC_SUBST(PATH_TO_LUA)
AC_SUBST(PATH_TO_HASHSUM)
AC_PATH_PROGS(PATH_TO_HASHSUM, [sha1sum] [md5sum], "")
AC_PATH_PROG(pager,[more], "")
PATH_TO_PAGER=$pager

AC_PATH_PROG(luaprog, lua, "")
if test x$luaprog = "x"; then
  echo The program "lua" must be in your path
  exit
fi
PATH_TO_LUA=$(echo $luaprog | sed -e 's|/lua$||')

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

echo -n "Checking for lua modules: posix lfs"

missingModules=""
for i in posix lfs; do
  $luaprog luaModuleAvailable $i 2> /dev/null
  if test "$?" != 0 ; then
    missingModules="$missingModules $i"
  fi
done

rm luaModuleAvailable
if test -n "$missingModules" ; then
  echo ""
  echo ""
  echo "Error: The follow lua module(s) are missing: $missingModules"
  echo ""
  echo "You can not run Lmod without: $missingModules"
  exit 1
fi

echo "... yes"
    
AC_SUBST(LUA_INCLUDE)
AC_SUBST(LUA_LIB)

LUA_INCLUDE=$PATH_TO_LUA_DIR/include
LUA_LIB=$PATH_TO_LUA_DIR/lib

if ! test -f $LUA_INCLUDE/lua.h; then
  AC_PATH_PROG(pkgConfig, pkg-config, "")
  if  ! test x$pkgConfig = "x"; then
    for i in lua5.2 lua5.1 lua; do
      $pkgConfig --exists $i
      if test $? = 0; then
        LUA_INCLUDE=`$pkgConfig --cflags $i | sed -e 's/^-I//'`
	LUA_LIB=`$pkgConfig --libs $i`
        break
      fi
    done
  fi
fi

AC_OUTPUT(makefile:Makefile.in)


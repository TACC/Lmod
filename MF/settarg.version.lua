local base        = "@PKG@/settarg"
local settarg_cmd = pathJoin(base, "@settarg_cmd@")

prepend_path("PATH",base)
setenv("LMOD_SETTARG_CMD", settarg_cmd)
set_shell_function("settarg", 'eval $($LMOD_SETTARG_CMD -s sh "$@")',
                              'eval `$LMOD_SETTARG_CMD  -s csh $*`' )

set_shell_function("gettargdir",  'builtin echo $TARG', 'echo $TARG')

local respect = "true"
setenv("SETTARG_TAG1", "OBJ", respect )
setenv("SETTARG_TAG2", "_"  , respect )

local full_support = (os.getenv("LMOD_FULL_SETTARG_SUPPORT") or
                      os.getenv("LMOD_SETTARG_FULL_SUPPORT") or "no"):lower()
if (full_support ~= "no") then
   set_alias("cdt", "cd $TARG")
   set_shell_function("targ",  'builtin echo $TARG', 'echo $TARG')
   set_shell_function("dbg",   'settarg "$@" dbg',   'settarg $* dbg')
   set_shell_function("empty", 'settarg "$@" empty', 'settarg $* empty')
   set_shell_function("opt",   'settarg "$@" opt',   'settarg $* opt')
   set_shell_function("mdbg",  'settarg "$@" mdbg',  'settarg $* mdbg')
end

local myShell = myShellName()
local exitCmd = "eval `" .. "@path_to_lua@ " .. settarg_cmd .. " -s " .. myShell .. " --destroy`"
execute{cmd=exitCmd, modeA = {"unload"}}

local titlebar_support = (os.getenv("LMOD_SETTARG_TITLE_BAR") or "no"):lower()
local term             = os.getenv("TERM") or " "

if (titlebar_support == "yes") then
   if (myShellName() == "bash" or myShellName() == "zsh") then
      local precmd = [==[{
             local tilde="~";
             local H=${HOSTNAME-$(hostname)};
             H=${H%%.*};
             local SHOST=${SHOST-$H};
             eval $(${LMOD_SETTARG_CMD:-:} -s bash);
             ${SET_TITLE_BAR:-:} "${TARG_TITLE_BAR_PAREN}${USER}@${SHOST}:${PWD/#$HOME/$tilde}";
             ${USER_PROMPT_CMD:-:};
           }
      ]==]
      set_shell_function("precmd",precmd,"")
      if (term:find("xterm")) then
         setenv("SET_TITLE_BAR","xSetTitleLmod")
         execute{cmd='echo -n -e "\\033]2; \\007"',modeA={"unload"}}
      end
      if (myShellName() == "bash") then
         pushenv("PROMPT_COMMAND","precmd")
      end
   elseif (myShellType() == "csh") then
      set_alias("cwdcmd",'eval `$LMOD_SETTARG_CMD -s csh`')
      if (term:find("xterm")) then
         set_alias("precmd",'echo -n "\\033]2;${TARG_TITLE_BAR_PAREN}${USER}@${HOST} : $cwd\\007"')
         execute{cmd='echo -n "\\033]2; \\007"',modeA={"unload"}}
      end
   end
end
if (myShellType() == "csh") then
   execute{cmd='setenv LMOD_SETTARG_CMD :',modeA={"unload"}}
end


local helpMsg = [[
The settarg module dynamically and automatically updates "$TARG" and a
host of other environment variables. These new environment variables
encapsulate the state of the modules loaded.

For example, if you have the settarg module and gcc/4.7.2 module loaded
then the following variables are defined in your environment:

   TARG=OBJ/_x86_64_06_1a_gcc-4.7.3
   TARG_COMPILER=gcc-4.7.3
   TARG_COMPILER_FAMILY=gcc
   TARG_MACH=x86_64_06_1a
   TARG_SUMMARY=x86_64_06_1a_gcc-4.7.3

If you change your compiler to intel/13.1.0, these variables change to:

   TARG=OBJ/_x86_64_06_1a_intel-13.1.0
   TARG_COMPILER=intel-13.1.0
   TARG_COMPILER_FAMILY=intel
   TARG_MACH=x86_64_06_1a
   TARG_SUMMARY=x86_64_06_1a_intel-13.1.0

If you then load mpich/3.0.4 module the following variables automatically
change to:

   TARG=OBJ/_x86_64_06_1a_intel-13.1.0_mpich-3.0.4
   TARG_COMPILER=intel-13.1.0
   TARG_COMPILER_FAMILY=intel
   TARG_MACH=x86_64_06_1a
   TARG_MPI=mpich-3.0.4
   TARG_MPI_FAMILY=mpich
   TARG_SUMMARY=x86_64_06_1a_dbg_intel-13.1.0_mpich-3.0.4

You also get some TARG_* variables that are always available, independent
of what modules you have loaded:

   TARG_MACH=x86_64_06_1a
   TARG_MACH_DESCRIPT=...
   TARG_HOST=...
   TARG_OS=Linux-3.8.0-27-generic
   TARG_OS_FAMILY=Linux

One way that these variables can be used is part of a build system where
the executables and object files are placed in $TARG.  You can also use
$TARG_COMPILER_FAMILY to know which compiler you are using so that you
can set the appropriate compiler flags.

If the environment variable LMOD_SETTARG_FULL_SUPPORT is set to "yes"
then helpful aliases are defined to set the debug/optimize/max debug
build scenerio

If the environment variable LMOD_SETTARG_TITLE_BAR is set to "yes" then
the xterm title will be set with along with important modules like the
compiler and mpi stack.


Settarg can do more.  Please see the Lmod website for more details.
]]

help(helpMsg)

.. _sh_to_modulefile-label:

Shell scripts and Lmod
======================

Some application provide shell scripts to initialize their use.  The
drawbacks of this approach is that applications would have to provide
scripts for each shell and there was typically no way to unload the
application.  Also users of shells other than bash or (t)csh were also
usually out of luck.

Lmod, like other environment module system are used by tools that are
not shells such as cmake, R, perl, python, etc. So application shell
scripts there weren't helpful there either.  Modules provide a way to
support the other shells and non-shell applications.

Lmod has provided **sh_to_modulefile** to convert scripts to
modulefiles. New in version 8.6+, Lmod provides support for
**source_sh** () to source shells scripts *inside* a modulefile.
This provides several features at a cost. It means that it can be used
by all module applications *and it can be unloaded*.  The cost is that
Lmod is evaluating the shell script in a subshell extract the module
commands every time that module is loaded. So it is typically better
to convert it once with **sh_to_modulefile**.



Converting shell scripts to modulefiles
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Lmod provides a script called *sh_to_modulefile* which will convert a
script to a modulefile.  An example is::

    % $LMOD_DIR/sh_to_modulefile  ./foo.sh > foo_1.0.lua

or::

    % $LMOD_DIR/sh_to_modulefile  --output foo_1.0.lua ./foo.sh

This program defaults to generating a lua based modulefile.  It is
possible to generate a TCL modulefile with::

    % $LMOD_DIR/sh_to_modulefile  --to TCL --output foo_1.0 ./foo.sh

See::

    % $LMOD_DIR/sh_to_modulefile  --help

for all the options.

The way it works is that remembers the initial environment and runs
the script.  The program then compares the initial environment and
generate environment.  The output is a report of the environment
changes.

As of version 8.6, Lmod now tracks changes to shell aliases and shell
functions and writes them to the generated modulefile.

Converting scripts once with this command is usually best.  However,
some scripts depend on dynamic environment variable that change
between users such as the values of $HOME or $USER. In this case, the
use of the **source_sh** () modulefile function can be helpful.

Using **source_sh** ()
^^^^^^^^^^^^^^^^^^^^^^
The feature of sourcing shell scripts inside a modulefile was
introduced in Tmod 4.6+.  It has be shamelessly studied and
re-implemented in Lmod 8.6+. In Lmod, this feature re-uses much of the
code that implements **sh_to_modulefile**.  This code does the
following when performing a module load.

#. Gets the current environment, shell aliases and shell functions
#. Sources the shell script with arguments
#. Compares the new environment to extract module commands

The resulting modules commands are stored in the user environment
inside the module table which can be shown by running **$ module
--mt**.

When unloading or showing, the module commands are extracted from the
module table and used to unload the changes that the script caused.
In other words, the shell script is only evaluated when loaded. not on
unload.

   **Note**: Occasionly, application scripts will provide a "deactivate" that a
   site might be temped to use like this::

      if (mode() == "unload") then
         source_sh("bash", "app_script deactivate")
      end

   **Do not do this!**  the function **source_sh** expects to find the
   module function in the module table in the environment.  It is
   better to do this for load and unload::
   
      source_sh("bash", "app_script activate")

   and let Lmod unload the scripts via the generated module functions.
     
Sites can dynamically build the shell script and argument string.  It
is important however that this string be the same for both load and
unload because this string is part of the access method to extract the
commands from the module table.

Assumptions that Lmod makes about scripts used by **source_sh** ()
------------------------------------------------------------------

Lmod assumes that these scripts **DO NOT** have module commands or
change $MODULEPATH.


Shell script are evaluated with set -e
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Shell scripts are evaluated by sh_to_modulefile and the source_sh()
function with set -e in bash or equivalently in
other shells.  This means that execution of the shell script stops at
the first time a statement in the script has a non-zero status.
Turning this option on means that Lmod can know that the evaluation of
the shell script has an issue.  But this also means that sometimes a
script would work fine without using "set -e".

Assuming the script is a bash script, please do the following::

   $ set -exv ; . ./my_script

This should tell you where the issue was found.  Note that the error
may be in another script sourced by "my_script". In particular, you
might have a silent error.  For example, a bash script might have a
line::

   unalias some_alias_name 2> /dev/null

where "some_alias_name" is not currently an alias. This unalias statement
returns a non-zero status but is silent because of the redirection of
stderr to /dev/null.  One fix might be::

   unalias some_alias_name 2> /dev/null || true


Calling the shell script directly inside a modulefile
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Site can also use the execute{} function inside a modulefile. This
function add the shell script text at the end of the string that is
evaluated by the shell.  This execute command only makes sense if the
evaluation is by the appropriate shell.

If a site wants to place the shell command first then they can use the
print() statement as this will appear first.  For example, to have the
script appear before the unset environment commands then do this::

   if (mode() == "unload") then
      print("app_script deactivate")
   end

The string  **"app_script deactivate"** will be generated before any
other environment commands will generated.



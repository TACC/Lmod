The Interaction between Modules, MPI and Parallel Filesystems
=============================================================

Many sites that use modules have hundred to thousands of nodes
connected to large parallel filesystems.  Some care has to be taken
when a user's job scripts start a parallel mpi execution to avoid
problems with the parallel filesystem.  Module commands in a user's
~/.bashrc or ~/.cshrc can overload or cause timeouts in a parallel
filesystem.

At TACC, we do a couple of things to avoid this problem. We have seen
this timeout problem for mpi programs that execute more than 1000
nodes, but when this problem occurs will depend on relative speeds of
the network and the parallel filesystem.

It is helpful to outline the procedure that we use at TACC to start a
job on a compute node for a user 

#. The bash user submits a job to the scheduler.
#. The current environment is captured
#. That environment passed to the shell script that starts on a
   compute node.
#. The user's job script starts an mpi execution.
#. The mpi execution starts an interactive non-login (and not prompt)
   shell on every node.
#. This non-login interactive shell sources the user's ~/.bashrc
#. Then the environment found at the start of mpi execution is passed
   to all nodes.

It is the sixth step that causes the problem.  If there are any module
load commands in ~/.bashrc, these module commands will be started on
every node at about the same time.  The module command has to walk the
directories listed in $MODULEPATH to find the modules.  This hits the
parallel filesystem hard when there are thousands of nodes.


At TACC we define an environment variable call ``ENVIRONMENT`` (a clever
name, no?) to be ``BATCH`` when a job is started on a compute node.
We provide every user with a default ~/.bashrc that has the following
section::

     if [ -z "$__BASHRC_SOURCED__" -a "$ENVIRONMENT" != BATCH ]; then
       export __BASHRC_SOURCED__=1

       ##########################################################
       # **** PLACE MODULE COMMANDS HERE and ONLY HERE.      ****
       ##########################################################

       # module load git

     fi   

This way modules are only loaded once on the initial shell and not
reloaded on subshells or on compute nodes during job submission.

Some users won't follow our guidelines so as an extra layer of
protection we make the module be a no-op for bash users.

The module command for bash is defined to be::

   module () {
      eval $( $LMOD_CMD bash "$@" ) ...
   }

Normally, ``$LMOD_CMD`` points the lmod command but on compute nodes
we have the following startup behavior for bash users::

    # Compute notes set the ENVIRONMENT var to BATCH for non-interactive shells.
    if [ -z "$PS1" ]; then
      export ENVIRONMENT=BATCH

      # If we are in BATCH mode then turn off the module command.
      if [ -z "$TACC_DEBUG" ]; then
        export LMOD_CMD=':'
        export LMOD_SETTARG_CMD=':'
      fi
    fi  


By making ``$LMOD_CMD`` be a colon, we make the module command
silently do nothing. Unfortunately, this only works for bash and not
tcsh or zsh users.  We want module command to work in a user's job
submission script::

    #!/bin/bash
    #SBATCH ...

    module load intel mvapich2
    ibrun ./my_mpi_program        # start parallel execution.

Note that the total environment is passed by our parallel job starter
ibrun.  So there is no need for a user's ~/bashrc or similar file to
load modules. In fact it can lead to problems if the user's current
module environment loads modules that don't match the environment that
ibrun pushes to the compute nodes.

Tcsh and Zsh source the startup scripts sourced in /etc/profile.d/ for
shell script startup.  This is how the module command is defined
there.  If we redefined ``$LMOD_CMD`` for those shell, module command
would not work in tcsh or zsh scripts.

Bash uses a different technique.  It only uses the value of $BASH_ENV.
If that variable points to a file then that file is source.  Lmod
defines that variable to point to a file that defines the module
command.  So re-defining ``$LMOD_CMD`` in the startup scripts won't
affect the module commands in the job submission script, just in the
parallel execution when ~/.bashrc is sourced.

One drawback to redefining ``$LMOD_CMD`` is that if bash user tries to
invoke a shell script to run in parallel any module command will
silently do nothing.

Module names and module naming conventions
==========================================

The modulefiles contain commands that change the user's environment to
make an application or library available to a user.  So loading a modulefile
named gcc/7.1 should hopefully make the programs Gnu Compiler
Collection (i.e. gcc, gfortran and g++ compilers) available to a user.

So the ``gcc/7.1`` module is a file named either 7.1 or 7.1.lua depending
on whether the commands are written in TCL or Lua respectively and
this file is in the ``gcc`` directory.

To see a more complete module layout, let's assume your site has
has a MODULEPATH set to::

   /apps/modulefiles/Core:/apps/modulefiles/Other

And the directory layout from /apps/modulefiles is::

   $ cd /apps/modulefiles; tree -a
   .
   ├── Core
   │   ├── A
   │   │   ├── 1.0
   │   │   └── 2.0.lua
   │   ├── gcc
   │   │   ├── 5.4
   │   │   └── 7.1.lua
   │   └── StdEnv.lua
   └── Other
       ├── C
       │   ├── 3.3.lua
       │   └── 3.4.lua
       └── D
           └── 4.0.lua

In the above structure there are 8 modulefiles.  So the 5
modulefiles under Core are: A/1.0, A/2.0, gcc/5.4, gcc/7.1 and
StdEnv.  Note that Lmod's name of a modulefile doesn't include the
.lua extension.  Also note that both A and gcc have two versions where
as StdEnv has a name with no version.

fullName == sn/version
~~~~~~~~~~~~~~~~~~~~~~

The fullName of a modulefile is complete name which is made of two
parts: sn and version.  The sn is the shortname and represents the
minimum name that can be used to specify a module.  So for the
``gcc/7.1`` modulefile.  The fullName is ``gcc/7.1`` and the sn is
``gcc`` and the version is ``7.1``.  This naming convention is known
as NAME/VERSION and is abbreviated N/V.  There are two more complicated
naming schemes known as Category/Name/Version (a.k.a. C/N/V) and
Name/Version/Version (a.k.a N/V/V).  In all three naming schemes, a
modulefile has a fullName which is split into sn / version.  The split
between the sn and version will be different depending on which naming
scheme is used.  Sometimes the version doesn't exist like for StdEnv
module. In this case the fullName is the same as the sn.

In next section :ref:`modulepath-label`, we explain how a Lmod takes
an ``sn`` and determines which modulefile to load.  But in short, Lmod
picks the marked default or if there is no default then Lmod picks the
"highest" version.

Special Names for modulefiles
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the version has a leading dot then this modulefile is hidden.  That
is, it can be loaded but it won't be shown by ``module avail``. If the
sn name has a leading dot, such as ``.X`` then every version of this
module will be hidden.   So ``.X/1.0`` is hidden and so is ``Y/.2.0``.

Because of the way that Lmod passes information between module command
invocations, a modulefile **CANNOT** have two or more leading
underscores. So naming a modulefile ``_A/1.0`` is acceptable but
having two underscore such as ``__B/1.0`` is not!

Module Naming scheme: Category/Name/Version (C/N/V)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sites may wish to group similar modules into categories.  For example,
all the biology packages grouped together, like bowtie and tophat
packages be named: ``bio/bowtie/3.4`` or ``bio/tophat/2.7``.  When the
fullName is ``bio/bowtie/3.4`` then the sn for is ``bio/bowtie`` and the
version is ``3.4``.

Sites should think carefully about choosing to using C/N/V.  This can
make it easier for users to know which modules provide say physics, 
chemistry or biology applications but it does lead to great deal more
typing of which tab completion provided by the bash or zsh shells can
only do so much.

Sites can have meta-module inside a category. A meta-module is a
module that has no version.  For example, suppose you have the
following C/N/V modulefile structure:: 

     $ cd /apps/modulefiles/Other; tree -a 
     .    
     └── bio
         ├── bowtie
         │   └── 3.1
         ├── genomics.lua
         └── tophat
             └── 7.2

In this case there are three modules ``bio/bowtie/3.1``,
``bio/tophat/7.2``. The ``bio/genomic`` module is a meta module where
the fullName is the same as the sn and it has no version.

The rule that Lmod uses to determine which modules are meta modules
and which have a version is the following.  If a file is in a
directory that has other sub-directories (other than `.` and `..`),
the file is a meta-module.  So the genomic.lua file is part of the sn
for bio/genomics because the genomics.lua file is in a sub-directory
that has the directories ``bowtie`` and ``tophat``.

Sites can mix N/V and C/N/V layouts, Lmod will be able to decide the
sn and versions by walking directory tree. In general, the fullName,
will be divided into directories names to become the sn and the
version will be the file.  So for the fullName ``bio/tophat/7.2`` the
directories bio and tophat become the sn, ``bio/tophat`` and the
version is ``7.2``.

Lmod supports as many directory levels as site likes.  For example, a
site could have a modulefile named ``A/B/C/D/1.1`` where the sn name
is ``A/B/C/D`` and the version is ``1.1``.


Module Naming scheme: Name/Version/Version (N/V/V)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A site many wish to have directories has part of the version. This
could be used to have 32 or 64 bit versions of the same package. So for
example a site might wish to have a modules named ``acme/32/4.2`` and
``acme/64/4.2`` where sn is ``acme`` and the versions are ``32/4.2``
and ``64/4.2``.

By default, Lmod assumes that the version is just the file, so lmod
needs to be told where the sn / version split is.  This can be done by
creating an empty ``.version`` or ``.modulerc`` file where a site wants the
split to be.  For the above example, the following layout make
``acme`` be the sn::

   $ tree -a
   .
   └── acme
       ├── .version
       ├── 32
       │   └── 4.2
       └── 64
           └── 4.2

because there is a .version at the same level as the 32 and 64
directories.  With the .version file, the fullName is ``acme/64/4.2``
and the sn is ``acme`` and the version ``64/4.2``.  If the .version
file was removed then the sn would be ``acme/64`` and the version
would be ``4.2``.

Sites are can name modules with as many directories as they like.  For
example a site can have a module named::

   mpi/mpich/64/3.1/048

If there is an empty file at ``mpi/mpich/.version`` then the sn
would be ``mpi/mpich`` and the version would be ``64/3.1/048``.  


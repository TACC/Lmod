The source code and Makefiles in this directory build a simple "hello
world" executable.  The goal here is to show how to use TARG and
TARG_COMPILER_FAMILY with gnu make.  There are two Makefile in this
directory: Makefile and Makefile.simple.  Makefile.simple is explicit
and does not use many gnu make tricks.

Makefile is more complicated and shows how to use automatically
generated dependencies.  This Makefile also use a recursive make
call.  The steps are as follows:

   1)  The command "make" is the same as "make all", since "all" is
       the first target in the Makefile.  It depends on the $(O_DIR)
       which is $TARG/ and the rule $(O_DIR) below makes sure that
       the directory is created if it doesn't exist.

   2) Once $(O_DIR) exists, rule cause a recursive make call to build
      the "_all" target.   The reason for the trick is at the bottom
      of the Makefile.  The first time the makefile is read
      $(MAKELELVEL) is zero so the include request is not active.  The
      recursive make call bumps $(MAKELEVEL) to 1.  This makes the
      include request to become active.  If these files do not exist
      then the rule $(O_DIR)%.d: %c is used.  This rule uses the
      compiler to generate the dependency for a single file.  So for
      the $(O_DIR)/main.d the contents are:

          $(O_DIR)/main.o $(O_DIR)/main.d: main.c hello.h

      This says that both the *.o and the *.d files depend on main.c
      and hello.h.  So if either main.c or hello.h change then both
      the *.d and *.o files will be updated.


   3) Once the dependencies resolved, the compilation of
      $(O_DIR)main.o and $(O_DIR)hello.o takes place and then the link
      completes the building of $(O_DIR)hello.



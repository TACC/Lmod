########################################################################
#  Use TARG_COMPILER_FAMILY to set the C compiler name

ifeq ($(TARG_COMPILER_FAMILY),gcc)
   CC := gcc
endif

ifeq ($(TARG_COMPILER_FAMILY),intel)
   CC := icc
endif


########################################################################
#  Use O_DIR as equal to $(TARG)/ so that if TARG is empty then O_DIR
#  will be empty.  But if $(TARG) as a value then O_DIR will have a
#  trailing slash.

ifneq ($(TARG),)
  override O_DIR := $(TARG)/
endif

########################################################################
#  Use TARG_BUILD_SCENARIO to set the compiler options for either
#  debug or optimize.

ifeq ($(TARG_BUILD_SCENARIO),dbg)
  CF := -g -O0
endif

ifeq ($(TARG_BUILD_SCENARIO),opt)
  CF := -O3
endif




DEPENDENCY_FLAG   := -MM
EXEC 		  := $(O_DIR)hello
SRC  		  := main.c hello.c
OBJS 		  := $(patsubst %.c, $(O_DIR)%.o, $(SRC))
override CFLAGS   := $(CFLAGS) $(CF)

all: $(O_DIR)
	$(MAKE) _all

_all:  $(EXEC)

$(O_DIR):
	mkdir -p $(O_DIR)

$(EXEC): $(OBJS)
	$(LINK.c) -o $@ $^

neat:
	$(RM) *~

clean: neat
	$(RM) $(OBJS)
clobber: clean
	$(RM) $(EXEC)
	$(RM) -r $(TARG) $(TARGET_PREFIX)





######################## compilation rules ###############################

$(O_DIR)%.o : %.c
	$(COMPILE.c) -o $@ -c $<

$(O_DIR)%.d: %.c
	$(SHELL) -c '$(CC) $(CFLAGS) -I $(O_DIR) $(DEPENDENCY_FLAG) $<             \
        | sed -e '\''s;\($*\)\.o[ :]*;$$(O_DIR)\1.o $$(O_DIR)$(notdir $@) : ;g'\'' \
              -e '\''s;$(O_DIR);$$(O_DIR);'\''                		           \
                                                         > $@;           	   \
	[ -s $@ ] || rm -f $@'

######################## Dependancies ####################################

ifneq (0,$(MAKELEVEL))
  include $(patsubst %.c,   $(O_DIR)%.d, $(SRC))
endif

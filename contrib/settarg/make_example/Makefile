
ifeq ($(TARG_COMPILER_FAMILY),gcc)
   CC := gcc
endif

ifeq ($(TARG_COMPILER_FAMILY),intel)
   CC := icc
endif

ifneq ($(TARG),)
  override O_DIR := $(TARG)/
endif


DEPENDENCY_FLAG   := -MM
EXEC 		  := $(O_DIR)hello
SRC  		  := main.c hello.c
OBJS 		  := $(patsubst %.c, $(O_DIR)%.o, $(SRC))

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

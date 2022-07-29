SONAME   := tcl2lua.so
SONAMEV  := $(SONAME).1
LIBRARY  := $(SONAMEV).0.1
SRC      := tcl2lua.c
OBJ      := $(patsubst %.c, %.o, $(SRC))
OS       := $(shell uname -s)


ifeq ($(OS),Darwin)
  LIB_OPTION := -bundle -undefined dynamic_lookup #for MacOS X
else
  LIB_OPTION := -shared -Wl,-soname,$(SONAMEV) #for Linux
endif
override CFLAGS   := $(CFLAGS) -DLUA_COMPAT_MODULE -fPIC $(LUA_INC) $(TCL_INCLUDE)

all:  $(LIBRARY) $(SONAMEV) $(SONAME)

$(SONAMEV):
	ln -s $(LIBRARY) $@

$(SONAME):
	ln -s $(SONAMEV) $@

$(LIBRARY): $(OBJ)
	$(CC) $(CFLAGS) $(LIB_OPTION) -o $(LIBRARY) $(OBJ) $(LDFLAGS) -lc $(LIBS) $(TCL_LIBS)

install: all
	install -m $(MODE_R) *.so* $(LIB)

clean:	neat
	$(RM) $(LIBRARY) $(SONAMEV) $(SONAME)
neat:
	$(RM) *~ *.o

echo:
	@echo $(OBJ)

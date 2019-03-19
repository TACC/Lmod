SONAME   := rtm.so
SONAMEV  := $(SONAME).1
LIBRARY  := $(SONAMEV).0.1
SRC      := lua_try.c
OBJ      := $(patsubst %.c, %.o, $(SRC))
LUAINC   := /opt/apps/lua/lua/include
OS       := macosx

override CFLAGS   := $(CFLAGS) -DLUA_COMPAT_MODULE -fPIC -I $(LUAINC)

ifeq ($(OS),macosx)
  LIB_OPTION= -bundle -undefined dynamic_lookup #for MacOS X
else
  LIB_OPTION= -shared -Wl,-soname,$(SONAMEV) #for Linux
endif

all:  $(LIBRARY) $(SONAMEV) $(SONAME)

$(SONAMEV):
	ln -s $(LIBRARY) $@

$(SONAME):
	ln -s $(SONAMEV) $@

$(LIBRARY): $(OBJ)
	$(CC) $(CFLAGS) $(LIB_OPTION) -o $(LIBRARY) $(OBJ) -lc

install: all
	cp $(LIBRARY) $(LUA_LIB)

clean:	neat
	$(RM) $(LIBRARY) $(SONAMEV) $(SONAME)
neat:
	$(RM) *~ *.o

echo:
	@echo $(OBJ)

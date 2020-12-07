SONAME   := core.so
SONAMEV  := $(SONAME).1
LIBRARY  := $(SONAMEV).0.1
SRC      := core.c
OBJ      := $(patsubst %.c, %.o, $(SRC))

override CFLAGS  := $(CFLAGS) -fPIC

ifneq ($(LUA_INC),)
  override CFLAGS  := $(CFLAGS) $(LUA_INC)
endif

OS := $(shell uname -s)
ifeq ($(OS),Darwin)
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
	$(CC) $(CFLAGS) $(LIB_OPTION) -o $(LIBRARY) $(OBJ) $(LDFLAGS) -lc

install: $(SHARE)/term $(LIB)/term all
	cp -a *.so* $(LIB)/term
	cp term/*.lua $(SHARE)/term

$(LIB)/term $(SHARE)/term:
	mkdir -p $@


clean:	neat
	$(RM) $(LIBRARY) $(SONAMEV) $(SONAME)
neat:
	$(RM) *~ *.o

echo:
	@echo $(OBJ)

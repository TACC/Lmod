T        := lfs
SONAME   := $(T).so
SONAMEV  := $(SONAME).1
LIBRARY  := $(SONAMEV).0.1
SRC      := $(T).c
OBJ      := $(patsubst %.c, %.o, $(SRC))
OS       := $(shell uname -s)

ifeq ($(OS),Darwin)
  LIB_OPTION := -bundle -undefined dynamic_lookup #for MacOS X
else
  LIB_OPTION := -shared -Wl,-soname,$(SONAMEV) #for Linux
endif

override CFLAGS  := $(CFLAGS) -fPIC $(LUA_INC)


all:  $(LIBRARY) $(SONAMEV) $(SONAME)

$(SONAMEV):
	ln -s $(LIBRARY) $@

$(SONAME):
	ln -s $(SONAMEV) $@

$(LIBRARY): $(OBJ)
	$(CC) $(CFLAGS) $(LIB_OPTION) -o $(LIBRARY) $(OBJ) $(LDFLAGS) -lc

install: $(LIB) all
	cp -a *.so* $(LIB)

$(LIB):
	mkdir -p $(LIB)

clean:	neat
	$(RM) $(LIBRARY) $(SONAMEV) $(SONAME)
neat:
	$(RM) *~ *.o

echo:
	@echo $(OBJ)

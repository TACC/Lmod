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

# Shared-library versioning: install only the real library (LIBRARY), then create
# symlinks SONAMEV->LIBRARY and SONAME->SONAMEV. Using "install *.so*" would
# copy symlink targets into full duplicates; we explicitly install + ln -s instead.
install: $(SHARE)/term $(LIB)/term all
	install -m $(MODE_R) $(LIBRARY) $(LIB)/term
	$(RM) -f $(LIB)/term/$(SONAMEV) $(LIB)/term/$(SONAME)
	ln -s $(LIBRARY) $(LIB)/term/$(SONAMEV)
	ln -s $(SONAMEV) $(LIB)/term/$(SONAME)
	install -m $(MODE_R) term/*.lua $(SHARE)/term

$(LIB)/term $(SHARE)/term:
	mkdir -p $@


clean:	neat
	$(RM) $(LIBRARY) $(SONAMEV) $(SONAME)
neat:
	$(RM) *~ *.o

echo:
	@echo $(OBJ)

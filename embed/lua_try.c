#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#define MYNAME   "rtm"
#define MYVERSION	MYNAME " library for " LUA_VERSION " / Mar 2019"

static int rtm_string(lua_State* L)
{
  const char * my_string  = "Now is the time!";
  const char * my_string2 = "for this to work!";
  lua_pushstring(L, my_string);
  lua_pushstring(L, my_string2);
  return 2;
}



int luaopen_rtm (lua_State *L)
{
  lua_newtable(L);
  lua_pushcfunction(L, rtm_string);
  lua_setfield(L, -2, "rtm_string");
  return 1;
}

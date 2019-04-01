#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <tcl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MYNAME        "tcl2lua"
#define MYVERSION      MYNAME " 0.1"

static char* resultStr = NULL;

int setResultsObjCmd(ClientData clientData, Tcl_Interp *interp, int objc, Tcl_Obj *CONST objv[])
{
  int      len;
  Tcl_Obj *objPtr;
  int i;
  if (objc != 2) {
    Tcl_WrongNumArgs(interp, 1, objv, "value");
    return TCL_ERROR;
  }
  objPtr = objv[1];

  resultStr  = Tcl_GetStringFromObj(objPtr, &len);
  if (resultStr[0] == '\0')
    {
      fprintf(stderr,"Result string has zero length\n");
      return TCL_ERROR;
    }

  return TCL_OK;
}

int Tcl_AppInit(Tcl_Interp* interp)
{
  if (Tcl_Init(interp) == TCL_ERROR)
    return TCL_ERROR;
  Tcl_CreateObjCommand(interp,"setResults", setResultsObjCmd, (ClientData) NULL, (Tcl_CmdDeleteProc *) NULL);
  return TCL_OK;
}

static int runTCLprog(lua_State *L)
{
  const char *cmd  = luaL_checkstring(L,1);
  const char *args = luaL_checkstring(L,2);
  char       boundary;
  const char *left;
  Tcl_Obj    *argvPtr;
  Tcl_Interp *interp;

  const char* p = args;

  size_t len, a;
  int argc = 0;
  int status = 1;

  Tcl_FindExecutable(cmd);
  interp = Tcl_CreateInterp();

  if (interp == NULL) {
    fprintf(stderr,"Cannot create TCL interpreter\n");
    exit(-1);
  }
  
  if (Tcl_AppInit(interp) != TCL_OK)
    return TCL_ERROR;

  Tcl_SetVar2Ex(interp, "argv0", NULL, Tcl_NewStringObj(cmd,-1), TCL_GLOBAL_ONLY);
  resultStr = NULL;
  argvPtr   = Tcl_NewListObj(0, NULL);

  /* By convention all tcl programs that use this interface use the "-F"
   * to signify that the script is using the fast option
   */

  Tcl_ListObjAppendElement(NULL, argvPtr, Tcl_NewStringObj("-F",-1));
  argc++;

  while (*p)
    {
      /* Skip leading spaces to get to the first argument */
      a    = strspn(p," \t");
      p   += a;
      left = p;
      if (*left == '\'' || *left == '"')
        {
          boundary = *left;
          left++;
        }
      else
        boundary = '\0';

      if (boundary)
        {
          p = left;
          while (1)
            {
              p = strchr(p,boundary);
              if (p == NULL)
                {
                  len = strlen(left);
                  break;
                }
              else if (p[-1] == '\\')
                {
                  p++;
                  continue;
                }
              len = p - left;
              break;
            }
          p++;
        }
      else
        {
          len = strcspn(left," \t");
          p   += len;
        }
      argc++;
      Tcl_ListObjAppendElement(NULL, argvPtr, Tcl_NewStringObj(left, len));
    }
  Tcl_SetVar2Ex(interp, "argc", NULL, Tcl_NewIntObj(argc), TCL_GLOBAL_ONLY);
  Tcl_SetVar2Ex(interp, "argv", NULL, argvPtr,             TCL_GLOBAL_ONLY);

  int result = Tcl_EvalFile(interp, cmd);
  status     = result == TCL_OK;

  fprintf(stderr,"Result string: \"%s\"\n",resultStr);

  lua_pushstring(L, resultStr);
  Tcl_DeleteInterp(interp);
  (resultStr) ?  lua_pushboolean(L, status): lua_pushboolean(L, 0);
  return 2;
}


int luaopen_tcl2lua(lua_State *L)
{
  lua_newtable(L);
  lua_pushcfunction(L, runTCLprog);
  lua_setfield(L, -2, "runTCLprog");
  return 1;
}

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <tcl/tcl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MYNAME        "runTCLprog"
#define MYVERSION      MYNAME " 0.1"

static char* resultStr;


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
    return TCL_ERROR;

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
  const char *cmd = luaL_checkstring(L,1);
  char       boundary;
  const char *left;
  char       *tcl_progName;
  Tcl_Obj    *argvPtr;
  Tcl_Interp *interp;

  const char* p = cmd;
  size_t len, a;
  int argc = 0;
  int status = 1;

  /* Get name of the tcl_progName: */
  a    = strspn(p," \t");
  p   += a;
  left = p;
  len  = strcspn(p, " \t");
  p   += len;
  
  tcl_progName = (char *)malloc(len*sizeof(char));
  memcpy(tcl_progName,left, len);
  tcl_progName[len] = '\0';
  Tcl_FindExecutable(tcl_progName);

  if (interp == NULL) {
    fprintf(stderr,"Cannot create TCL interpreter\n");
    exit(-1);
  }
  
  if (Tcl_AppInit(interp) != TCL_OK)
    return TCL_ERROR;

  Tcl_SetVar2Ex(interp, "argv0", NULL, Tcl_NewStringObj(tcl_progName,-1), TCL_GLOBAL_ONLY);
  resultStr = NULL;
  argvPtr   = Tcl_NewListObj(0, NULL);


  /* Skip leading spaces to get to the first argument */
  a    = strspn(p," \t");
  p   += a;
  left = p;

  while (*p)
    {
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
      a    = strspn(p," \t");
      p   += a;
      left = p;
    }
  Tcl_SetVar2Ex(interp, "argc", NULL, Tcl_NewIntObj(argc), TCL_GLOBAL_ONLY);
  Tcl_SetVar2Ex(interp, "argv", NULL, argvPtr,             TCL_GLOBAL_ONLY);

  status = Tcl_EvalFile(interp, p) == TCL_OK;
  
  free(tcl_progName);
  lua_pushstring(L, resultStr);
  (resultStr) ?  lua_pushboolean(L, status): lua_pushboolean(L, 0);
  return 2;
}


int luaopen_tclInterp(lua_State *L)
{
  lua_newtable(L);
  lua_pushcfunction(L, runTCLprog);
  lua_setfield(L, -2, "runTCLprog");
  return 1;
}

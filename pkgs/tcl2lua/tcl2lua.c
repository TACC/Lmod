#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <tcl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MYNAME        "tcl2lua"
#define MYVERSION      MYNAME " 0.1"

#if TCL_MAJOR_VERSION   < 9
  typedef int Tcl_Size;
#endif



typedef struct _results {
    char* resultStr;
    int   rlen;
} results_t;

/*
 * The sLiteral argument *must* be a string literal; the incantation with
 * sizeof(sLiteral "") will fail to compile otherwise.
 */
#define TclNewLiteralStringObj(objPtr, sLiteral) \
    (objPtr) = Tcl_NewStringObj( (sLiteral), (int) (sizeof(sLiteral "") - 1))

int setResultsObjCmd(ClientData clientData, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[])
{
  Tcl_Size len;
  Tcl_Obj *objPtr;
  results_t* results = (results_t*)clientData;

  if (objc != 2) {
    Tcl_WrongNumArgs(interp, 1, objv, "value");
    return TCL_ERROR;
  }
  objPtr = objv[1];

  char * str  = Tcl_GetStringFromObj(objPtr, &len);
  if (str[0] == '\0')
    {
      fprintf(stderr,"Result string has zero length\n");
      return TCL_ERROR;
    }

  if (len > results->rlen) 
    {
      free(results->resultStr);
      results->rlen      = len + 1;
      results->resultStr = (char *) malloc(results->rlen*sizeof(char));
    }
  memcpy(results->resultStr, str, len);
  results->resultStr[len] = '\0';
  return TCL_OK;
}

int Tcl_AppInit(Tcl_Interp* interp)
{
  if (Tcl_Init(interp) == TCL_ERROR)
    return TCL_ERROR;
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
  int        tcl_status;
  int        lua_status;

  const char* p = args;

  size_t len, a;
  int argc   = 0;

  results_t results;
  results.rlen = 1024;
  results.resultStr = (char *) malloc((results.rlen+1)*sizeof(char));
  strcpy(results.resultStr," ");

  Tcl_FindExecutable(cmd);
  interp = Tcl_CreateInterp();

  if (interp == NULL) {
    fprintf(stderr,"Cannot create TCL interpreter\n");
    exit(-1);
  }
  
  if (Tcl_AppInit(interp) != TCL_OK)
    return TCL_ERROR;

  Tcl_CreateObjCommand(interp,"setResults", setResultsObjCmd, (ClientData) &results, (Tcl_CmdDeleteProc *) NULL);

  Tcl_SetVar2Ex(interp, "argv0", NULL, Tcl_NewStringObj(cmd,-1), TCL_GLOBAL_ONLY);
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

  if ((tcl_status = Tcl_EvalFile(interp, cmd)) != TCL_OK)
    {
      Tcl_Channel chan = Tcl_GetStdChannel(TCL_STDERR);
      if (chan)
	{
	  Tcl_Obj *options = Tcl_GetReturnOptions(interp, tcl_status);
	  Tcl_Obj *keyPtr, *valuePtr;

	  TclNewLiteralStringObj(keyPtr, "-errorinfo");
	  Tcl_IncrRefCount(keyPtr);
	  Tcl_DictObjGet(NULL, options, keyPtr, &valuePtr);
	  Tcl_DecrRefCount(keyPtr);

	  if (valuePtr) 
	    Tcl_WriteObj(chan, valuePtr);
	  Tcl_WriteChars(chan, "\n", 1);
	  Tcl_DecrRefCount(options);
	}
    }

  lua_status  = (tcl_status == TCL_OK);
  lua_pushstring(L, results.resultStr);
  Tcl_DeleteInterp(interp);
  (results.resultStr) ?  lua_pushboolean(L, lua_status): lua_pushboolean(L, 0);
  free(results.resultStr);
  return 2;
}


int luaopen_tcl2lua(lua_State *L)
{
  lua_newtable(L);
  lua_pushcfunction(L, runTCLprog);
  lua_setfield(L, -2, "runTCLprog");
  return 1;
}

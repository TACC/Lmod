#include <tcl/tcl.h>
int Plus1ObjCmd(ClientData clientData, Tcl_Interp *interp, int objc, Tcl_Obj *CONST objv[])
{
  Tcl_Obj *objPtr;
  int i;
  if (objc != 2)
    {
      Tcl_WrongNumArgs(interp, 1, objv, "value");
      return TCL_ERROR;
    }

  objPtr = objv[1];
  if (Tcl_GetIntFromObj(interp, objPtr, &i) != TCL_OK)
    return TCL_ERROR;

  if (Tcl_IsShared(objPtr))
    {
      objPtr = Tcl_DuplicateObj(objPtr);
      Tcl_IncrRefCount(objPtr);
    }

  Tcl_SetIntObj(objPtr, i+1);

  Tcl_SetObjResult(interp, objPtr);
  Tcl_DecrRefCount(objPtr);

  return TCL_OK;
}

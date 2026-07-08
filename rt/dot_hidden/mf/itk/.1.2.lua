-- Issue #817 regression tree: dot-prefixed version file
whatis("itk dot-hidden version")
local usrName, trueUsrName = myModuleUsrAndAliasName()
setenv("IS817_ITK_LOADED","yes")
setenv("IS817_USR_ALIAS", usrName)
setenv("IS817_TRUE_ALIAS", trueUsrName)

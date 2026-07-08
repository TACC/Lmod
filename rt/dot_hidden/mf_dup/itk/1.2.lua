-- Duplicate-tree test: non-hidden exact key itk/1.2 alongside itk/.1.2
whatis("itk exact-key sibling for issue #817 ambiguity")
local usrName, trueUsrName = myModuleUsrAndAliasName()
setenv("IS817_ITK_SLOT", "exact")
setenv("IS817_USR_ALIAS", usrName)
setenv("IS817_TRUE_ALIAS", trueUsrName)

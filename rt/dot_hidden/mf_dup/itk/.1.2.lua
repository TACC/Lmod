-- Duplicate-tree test: dot-hidden itk/.1.2 alongside itk/1.2
whatis("itk dot-hidden sibling for issue #817 ambiguity")
local usrName, trueUsrName = myModuleUsrAndAliasName()
setenv("IS817_ITK_SLOT", "dot")
setenv("IS817_USR_ALIAS", usrName)
setenv("IS817_TRUE_ALIAS", trueUsrName)

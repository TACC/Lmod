-- Module with variable/environment patterns that should NOT be detected as markdown
help([[This module sets up environment variables and paths.

Environment variables use equals signs: PATH=/usr/bin:/usr/local/bin
Module variables include: MODULE_VERSION=1.0 and LUA_PATH=/usr/share/lua/5.3/?.lua

Variable names use underscores: MODULE_NAME, FILE_PATH, USER_HOME
Variable references use dollar signs: $HOME, ${PATH}, $MODULE_VERSION

Assignment statements appear as: export VAR=value and setenv("KEY", "VALUE")
Configuration lines use equals: option=value and setting = enabled

This content has many equals signs and underscores but should NOT be markdown.]])

whatis("Name: False Positive Variables Test")
whatis("Version: 1.0")
whatis("Description: Tests variable patterns that should not trigger markdown detection")

setenv("FALSE_POSITIVE_VARS_VERSION", "1.0")


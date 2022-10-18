Lmod design
===========

The style of variables is:
`varT`: a table
`varA`: an array

Spider
------

Spider searches for module(names). There are 3 levels of spider:
- level 0: just list all modules, no input given
- level 1: search for a module with a given name
- level 2: search for a module with a given name/version

Level 2 will show how to load the specified module in a hierarchy.

`canonical`: the version according to Lmod
`Version`: the version specify by whatis in the module (can be anything)
`pv`: Python version (used to determine the latest version)
`wv`: weighted version (user, system and module locale .modulerc)
`luaExt`: location of the .lua in the filename (zero when tcl module)

MainControl
--------------

The MainControl is the heart of Lmod. An 'action' in a module file like `setenv('foo', 'bar')` has a different
meaning depending on the mode. For a load it will set `foo` while for a unload it will delete it.
There are 7 modes in Lmod:
- Load
- Unload
- Access: for help and whatis messages
- CheckSyntax: check if the module file is a valid module (a dummy run)
- ComputeHash: generate a hash value for the contents of the module
- DependencyCk: check if all 'depends_on' are still valid after a unload
- MgrLoad: for a collection restore (loads are ignored)
- Refresh: reloads the modules to make sure all shell functions and aliases are defined
- Show: show the contents of the module
- Spider: process module files for spider operations

The file `MainControl.lua` holds all code and the files `MC_<mode>.lua` assign what each action in a
module exactly does. 

The object MCP (MainControl Program) is created once and always points to a 'positive'
action (a load basically). The lowercase mcp points to the current MainControl
Program. These variables are global.

The file `Hub.lua` is were the real work is being done. MainControl will decides which functions
get called from this file.

General flow
------------

The Lmod main is in `lmod.lua.in`. There the MainControl Program (MCP) object is created. The array
`lmodCmdA` does the translation between user input and a Lmod command. The file `cmdfuncs.lua` holds
all 'user' actions. The main will run a function from that file which will call MainControl which
calls Hub (or sometimes Hub directly).

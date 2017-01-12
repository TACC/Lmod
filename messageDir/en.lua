--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lmod is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2017 Robert McLay
--
--  Permission is hereby granted, free of charge, to any person obtaining
--  a copy of this software and associated documentation files (the
--  "Software"), to deal in the Software without restriction, including
--  without limitation the rights to use, copy, modify, merge, publish,
--  distribute, sublicense, and/or sell copies of the Software, and to
--  permit persons to whom the Software is furnished to do so, subject
--  to the following conditions:
--
--  The above copyright notice and this permission notice shall be
--  included in all copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
--  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
--  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
--  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
--  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
--  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
--  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--  THE SOFTWARE.
--
--------------------------------------------------------------------------

return {
   en = {
     errTitle  = "Lmod has detected the following error: ",
     warnTitle = "Lmod Warning: ",

     avail     = [==[Use "module spider" to find all possible modules.
Use "module keyword key1 key2 ..." to search for all possible modules matching any of the "keys".
]==],
     list      = " ",
     spider    = " ",
     aliasMsg  = "Aliases exist: foo/1.2.3 (1.2) means that \"module load foo/1.2\" will load foo/1.2.3",
     noModules = "No modules found!",



     e131      = "The module collection file is corrupt. Please remove: %{fn}\n",
     e132      = [==[The module table stored in the environment is corrupt.
please execute the command \" clearMT\" and reload your modules.
]==],
     e133      = [==[
The system default contains no modules
  (env var: LMOD_SYSTEM_DEFAULT_MODULES is empty)
  No changes in loaded modules

]==],

     m402      = "\nInactive Modules:\n",
     m403      = "\nActivating Modules:\n",
     m404      = "\nDue to MODULEPATH changes, the following have been reloaded:\n",
     m405      = "\nThe following have been reloaded with a version change:\n",
     m406      = "Restoring modules from %{msg}\n",
     m407      = [==[
%{border}
There are messages associated with the following module(s):
%{border}
]==],
     m408      = "Resetting modules to system default\n",
     m409      = ", for system: \"%{sname}\"",
     m410      = "Saved current collection of modules to: \"%{a}\"%{msgTail}\n",
     m411      = "No named collections.\n",
     m412      = [==[The command "module search" does not exist. To list all possible modules execute: 

  $   module spider %{s}

To search the contents of modules for matching words execute:

  $   module keyword %{s}
]==],
     m413      = "The following is a list of the modules currently available:\n",
     m414      = [==[%{border}
To learn more about a package execute:

   $ module spider Foo

where "Foo" is the name of a module.

To find detailed information about a particular package you
must specify the version if there is more than one version:

   $ module spider Foo/11.1

%{border}]==],
     m415     = "    Description:\n%{descript}\n\n",
     m416     = "     Versions:\n",
     m417     = [==[
     Other possible modules matches:
        %{b}
]==],
     m418     = [==[%{border}  To find other possible module matches execute:

      $ module -r spider '.*%{name}.*'

]==],
     m419      = [==[%{border}  For detailed information about a specific "%{key}" module (including how to load the modules) use the module's full name.
  For example:

     $ module spider %{exampleV}
%{border}]==],
     m420      = "\n    This module can be loaded directly: module load %{fullName}\n",
     m421      = "\n    You will need to load all module(s) on any one of the lines below before the \"%{fullName}\" module is available to load.\n",
     m422      = "\n    Additional variants of this module can also be loaded after loading the following modules:\n",
     m423      = "    Properties:\n",
     m424      = "\n     Other possible modules matches:\n        %{bb}\n",
     m425      = "\n  Where:\n",
     m426      = [==[The following modules were not unloaded:
  (Use "module --force purge" to unload all):
]==],
     m427      = "\nThe following sticky modules could not be reloaded:\n",

     w511      = [==[Failed to find the following module(s):  "%{quote_comma_list}" in your MODULEPATH
Try:

    $ module spider %{module_list}

to see if the module(s) are available across all compilers and MPI implementations.
]==],
     w512      = "Unknown hook: %{name}\n",

     ml_help   = [==[
   ml: A handy front end for the module command:

   Simple usage:
   -------------
     $ ml
                              means: module list
     $ ml foo bar
                              means: module load foo bar
     $ ml -foo -bar baz goo
                              means: module unload foo bar;
                                     module load baz goo;

   Command usage:
   --------------

   Any module command can be given after ml:

   if name is avail, save, restore, show, swap,...
       $ ml name  arg1 arg2 ...

   Then this is the same :
       $ module name arg1 arg2 ...

   In other words you can not load a module named: show swap etc.
]==],
     ml_opt    = [==[Option: "%{v}" is unknown.
  Try ml --help for usage.
]==],
     ml_2many  = "ml error: too many commands\n",
     
     --------------------------------------------------------------------------
     -- Usage Message
     --------------------------------------------------------------------------
     usage_cmdline = "module [options] sub-command [args ...]",
     help_title    = "Help sub-commands:\n" ..
                     "------------------",
     help1         = "prints this message",
     help2         = "print help message from module(s)",

     load_title    =  "Loading/Unloading sub-commands:\n" ..
                      "-------------------------------",
     load1         = "load module(s)",
     load2         = "Add module(s), do not complain if not found",
     load3         = "Remove module(s), do not complain if not found",
     load4         = "unload m1 and load m2",
     load5         = "unload all modules",
     load6         = "reload aliases from current list of modules.",
     load7         = "reload all currently loaded modules.",

     list_title    = "Listing / Searching sub-commands:\n" ..
                     "---------------------------------",
     list1         = "List loaded modules",
     list2         = "List loaded modules that match the pattern",
     list3         = "List available modules",
     list4         = "List available modules that contain \"string\".",
     list5         = "List all possible modules",
     list6         = "List all possible version of that module file",
     list7         = "List all module that contain the \"string\".",          
     list8         = "Detailed information about that version of the module.",
     list9         = "Print whatis information about module",
     list10        = "Search all name and whatis that contain \"string\".",

     srch_title    = "Searching with Lmod:\n" ..
                     "--------------------",
     srch0         = "  All searching (spider, list, avail, keyword) support regular expressions:",
     srch1         = "Finds all the modules that start with `p' or `P'",
     srch2         = "Finds all modules that have \"mpi\" in their name.",
     srch3         = "Finds all modules that end with \"mpi\" in their name.",

     collctn_title = "Handling a collection of modules:\n"..
                     "--------------------------------",
     collctn1      = "Save the current list of modules to a user defined \"default\" collection.",
     collctn2      = "Save the current list of modules to \"name\" collection.",
     collctn3      = "The same as \"restore system\"",
     collctn4      = "Restore modules from the user's \"default\" or system default.",
     collctn5      = "Restore modules from \"name\" collection.",
     collctn6      = "Restore module state to system defaults.",                                 
     collctn7      = "List of saved collections.",
     collctn8      = "Describe the contents of a module collection.",

     depr_title    = "Deprecated commands:\n" ..
                     "--------------------",
     depr1         = "load name collection of modules or user's \"default\" if no name given.",
     depr2         = "===> Use \"restore\" instead  <====",
     depr3         = "Save current list of modules to name if given, otherwise save as the default list for you the user.",
     depr4         = "===> Use \"save\" instead. <====",

     misc_title    = "Miscellaneous sub-commands:\n" ..
                     "---------------------------",
     misc1         = "show the commands in the module file.",
     misc2         = "Prepend or Append path to MODULEPATH.",
     misc3         = "remove path from MODULEPATH.",
     misc4         = "output list of active modules as a lua table.",


     env_title     = "Important Environment Variables:\n" ..
                     "--------------------------------",
     env1          = "If defined to be \"YES\" then Lmod prints properties and warning in color.",
     web_sites     = "Lmod Web Sites",
     rpt_bug       = "  To report a bug please read ",

     --------------------------------------------------------------------------
     -- LmodError messages
     --------------------------------------------------------------------------
     e101 = "Unable to find HashSum program (sha1sum, shasum, md5sum or md5).",
     e102 = "Unable to parse: \"%{path}\". Aborting!\n",
     e103 = "Error in LocationT:search().",
     e104 = "%{routine}: Did not find module entry: \"%{name}\". This should not happen!\n",
     e105 = "%{routine}: system property table has no %{location} for: \"%{name}\". \nCheck spelling and case of name.\n",
     e106 = "%{routine}: The validT table for %{name} has no entry for: \"%{value}\". \nCheck spelling and case of name.\n",
     e107 = "Unable to find: \"%{name}\".\n",
     e108 = "Failed to inherit: %{name}.\n",
     e109 = [==[Your site prevents the automatic swapping of modules with same name. You must explicitly unload the loaded version of "%{oldFullName}" before you can load the new one. Use swap to do this:

   $ module swap %{oldFullName} %{newFullName}

Alternatively, you can set the environment variable LMOD_DISABLE_SAME_NAME_AUTOSWAP to "no" to re-enable same name autoswapping.
]==],
     e110 = "module avail is not possible. MODULEPATH is not set or not set with valid paths.\n",
     e111 = "%{func}(\"%{name}\") is not valid; a value is required.",
     e112 = "Cannot load module \"%{name}\" because these module(s) are loaded:\n   %{module_list}\n",
     e113 = "Cannot load module \"%{name}\" without these module(s) loaded:\n   %{module_list}\n",
     e114 = "Cannot load module \"%{name}\". At least one of these module(s) must be loaded:\n   %{module_list}\n",
     e115 = [==[You can only have one %{name} module loaded at a time.
You already have %{oldName} loaded.
To correct the situation, please execute the following command:

  $  module swap %{oldName} %{fullName}

Please submit a consulting ticket if you require additional assistance.
]==],
     e116 = "Unknown Key: \"%{key}\" in setStandardPaths.\n",
     e117 = "No matching modules found.\n",
     e118 = "User module collection: \"%{collection}\" does not exist.\n  Try \"module savelist\" for possible choices.\n",
     e119 = "Collection names cannot contain a period ('.').\n  Please rename \"%collection}\"\n",
     e120 = "Swap failed: \"%{name}\" is not loaded.\n",
     e121 = "Unable to load module: %{name}\n     %{fn}: %{message}\n",
     e122 = "sandbox_registration: The argument passed is: \"%{kind}\". It should be a table.",
     e123 = "uuidgen is not available, fallback failed too",
     e124 = "Spider search timed out.\n",
     e125 = "dbT[sn] failed for sn: %{sn}\n",
     e126 = "Unable to compute hashsum.\n",
     e127 = [==[The following module(s) are unknown: %{module_list}

Please check the spelling or version number. Also try "module spider ..."
It is also possible your cache file is out-of-date; it may help to try:
  $   module --ignore-cache load %{module_list} 
]==],
     e128 = [==[These module(s) exist but cannot be loaded as requested: %{kA}
   Try: "module spider %{kB}" to see how to load the module(s).
]==],

     e129 = [==[Syntax error in file: %{fn}
 with command: %{cmdName}, one or more arguments are not strings.
]==],
     e130 = [==[Syntax error in file: %{fn}
with command: "execute".
The syntax is:
    execute{cmd="command string",modeA={"load",...}}
]==],
     --------------------------------------------------------------------------
     -- LmodMessages
     --------------------------------------------------------------------------
     m401 = "\nLmod is automatically replacing \"%{oldFullName}\" with \"%{newFullName}\".\n",
     
     --------------------------------------------------------------------------
     -- LmodWarnings
     --------------------------------------------------------------------------
     w501 = [==[One or more modules in your %{collectionName} collection have changed: "%{module_list}".
To see the contents of this collection execute:
  $ module describe %{collectionName}
To rebuild the collection, load the modules you wish, then execute:
  $ module save %{collectionName}
If you no longer want this module collection execute:
  $ rm ~/.lmod.d/%{collectionName}

For more information execute 'module help' or see http://lmod.readthedocs.org/
No change in modules loaded.

]==],
     w502 = "Badly formed module-version line: module-name must be fully qualified: %{fullName} is not.\n",
     w503 = "The system MODULEPATH has changed: please rebuild your saved collection.\n",
     w504 = "You have no modules loaded because the collection \"%{collectionName}\" is empty!\n",
     w505 = "The following modules were not loaded: %{module_list}\n\n",
     w506 = "No collection named \"%{collection}\" found.",
     w507 = "MODULEPATH is undefined.\n",
     w508 = "It is illegal to have a `.' in a collection name.  Please choose another name for: \"%{name}\".",
     w509 = "The named collection 'system' is reserved. Please choose another name.\n",
     w510 = [==[You are trying to save an empty collection of modules in "%{name}". If this is what you want then enter:
  $  module --force save %{name}
]==],
   }
}

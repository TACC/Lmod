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
--  Copyright (C) 2008-2018 Robert McLay
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

     --------------------------------------------------------------------------
     -- Error/Warning Titles
     --------------------------------------------------------------------------
     errTitle  = "Lmod has detected the following error: ",
     warnTitle = "Lmod Warning: ",

     --------------------------------------------------------------------------
     -- ml messages
     --------------------------------------------------------------------------

     ml_help               = [==[
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
     $ ml -- -I
                              means unload I not --ignore_cache
   Command usage:
   --------------

   Any module command can be given after ml:

   if name is a subcommand like avail, save, load, restore, show, swap,...
       $ ml name  arg1 arg2 ...

   All options must go before the subcommand:
       $ ml --terse avail

   Then this is the same :
       $ module name arg1 arg2 ...

   Shorthand:
   ----------
       ml r  -> ml restore
       ml s  -> ml save
       ml sl -> ml savelist
       ml sw -> ml swap

   Loading Modules named "r" or "spider" or other module commands
   --------------------------------------------------------------

   Any modules named "r" or any other module commands must be loaded like this:

      ml load r
      ml load spider
]==],
     ml_opt                = [==[Option: "%{v}" is unknown.
  Try ml --help for usage.
]==],
     ml_2many              = "ml error: too many commands\n",

     ml_misplaced_opt      = [==[ml error: misplaced option: "%{opt}"
  Try ml --help for usage.
]==],

     --------------------------------------------------------------------------
     -- LmodError messages
     --------------------------------------------------------------------------
     e_Args_Not_Strings    = [==[Syntax error in file: %{fn}
 with command: %{cmdName}, one or more arguments are not strings.
]==], --
     e_Args_Not_Table    = [==[Syntax error in file: %{fn}
 with function: %{func}, is not a table.
]==], --
     e_Args_Not_Strings_short = "command: %{cmdName}, one or more arguments are not strings.",
     e_Avail_No_MPATH      = "module %{name} is not possible. MODULEPATH is not set or not set with valid paths.\n",
     e_BadAlias            = "%{kind} names cannot contain spaces (Not: \"%{name}\")\n",
     e_BadName             = "%{kind} names must be start with a letter or underscore followed letters, numbers and underscores (Not: \"%{name}\")\n",
     e_BrokenCacheFn       = "Spider cache fn: \"%{fn}\" appears broken",
     e_BrokenQ             = "Internal error: broken module Q\n",
     e_Conflict            = "Cannot load module \"%{name}\" because these module(s) are loaded:\n   %{module_list}\n",
     e_Conflict_Downstream = "Cannot load module \"%{userName}\" because this module set a conflict: \"%{fullNameUpstream}\"\n",
     e_Delim               = "A bad delim has been given, delim must be a string: \"%{delim}\" for command: %{cmdName} in file: %{fn}",
     e_Dofile_not_supported = "The dofile() function is not supported.  Use require() or loadfile() or loadstring()",
     e_Execute_Msg         = [==[Syntax error in file: %{fn}
with command: "execute".
The syntax is:
    execute{cmd = "command string",modeA={"load",...}}
]==],
     e_Failed_2_Find       = "Unable to find: \"%{name}\".\n",
     e_Failed_2_Inherit    = "Failed to inherit: %{name}.\n",
     e_Failed_Hashsum      = "Unable to compute hashsum.\n",
     e_Failed_Load         = [==[The following module(s) are unknown: %{module_list}

Please check the spelling or version number. Also try "module spider ..."
It is also possible your cache file is out-of-date; it may help to try:
  $   module --ignore_cache load %{module_list}

Also make sure that all modulefiles written in TCL start with the string #%Module
]==],
     e_Failed_Load_2       = [==[These module(s) or extension(s) exist but cannot be loaded as requested: %{kA}
   Try: "module spider %{kB}" to see how to load the module(s).
]==],
     e_Failed_Load_any     = [==[The load_any function failed because it could not find any of the following modules : %{module_list}

Please check the spelling or version number. Also try "module spider ..."

Also make sure that all modulefiles written in TCL start with the string #%Module
]==],
     e_Failed_depends_any     = [==[The depends_on_any function failed because it could not find any of the following modules : %{module_list}

Please check the spelling or version number. Also try "module spider ..."

Also make sure that all modulefiles written in TCL start with the string #%Module
]==],

     e_Failed_2_Find_w_Access = [==[Failed to find the following module(s):  "%{quote_comma_list}" in your MODULEPATH
Try:

    $ module spider %{module_list}

to see if the module(s) are available across all compilers and MPI implementations.
]==],
     e_Family_Conflict     = [==[You can only have one %{name} module loaded at a time.
You already have %{oldName} loaded.
To correct the situation, please execute the following command:

  $  module swap %{oldName} %{fullName}

Please submit a consulting ticket if you require additional assistance.
]==],
     e_Forbidden           = "Access to %{fullName} is denied\n",
     e_Forbidden_w_msg     = "Access to %{fullName} is denied\n%{literal_msg}",
     e_Illegal_Load        = [==[The following module(s) are illegal: %{module_list}
Lmod does not support modulefiles that start with two or more underscores
]==],
     e_Illegal_option      = [==[Option: "%{v}" is unknown.
  Try module --help for usage.
]==],
     e_Inf_Loop            = "A load storm (possibly an infinite loop) detected for module: \"%{fullName}\" file: \"%{file}\". It was loaded more than %{count} times.\n",
     e_LocationT_Srch      = "Error in LocationT:search().",
     e_Missing_Action      = "Missing action internal error. sn=\"%{sn}\", msg=\"${msg}\"",
     e_Malformed_time      = "Before or after time is malformed. Please use YYYY-MM-DD or YYYY-MM-DDTHH:MM instead of \"%{tStr}\"\n",
     e_Missing_Value       = "%{func}(\"%{name}\") is not valid; a value is required.",
     e_MT_corrupt          = [==[The module table stored in the environment is corrupt.
please execute the command \" clearMT\" and reload your modules.
]==],
     e_No_table            = "%{name} is not table",
     e_No_AutoSwap         = [==[Your site prevents the automatic swapping of modules with same name. You must explicitly unload the loaded version of "%{oldFullName}" before you can load the new one. Use swap to do this:

   $ module swap %{oldFullName} %{newFullName}

Alternatively, you can set the environment variable LMOD_DISABLE_SAME_NAME_AUTOSWAP to "no" to re-enable same name autoswapping.
]==],  --
     e_No_Hashsum          = "Unable to find HashSum program (sha1sum, shasum, md5sum or md5).",
     e_No_Matching_Mods    = "No matching modules found.\n",
     e_No_Mod_Entry        = "%{routine}: Did not find module entry: \"%{name}\". This should not happen!\n",
     e_No_Period_Allowed   = "Collection names cannot contain a period ('.').\n  Please rename \"%collection}\"\n",
     e_No_PropT_Entry      = "%{routine}: system property table has no %{location} for: \"%{name}\". \nCheck spelling and case of name.\n",
     e_No_UUID             = "uuidgen is not available, fallback failed too",
     e_No_ValidT_Entry     = "%{routine}: The validT table for %{name} has no entry for: \"%{value}\". Make sure that all keys in displayT have a matching key in validT. \nCheck spelling and case of name.\n",
     e_Newer_posix_reqd    = "The site's luaposix is too old to use before or after modifiers to hide modules.  Please upgrade your sites luaposix.\n",
     e_Prereq              = "Cannot load module \"%{name}\" without these module(s) loaded:\n   %{module_list}\n",
     e_Prereq_Any          = "Cannot load module \"%{name}\". At least one of these module(s) must be loaded:\n   %{module_list}\n",
     e_Prioity             = "A bad priority has been given, priority must be a number: \"%{priority}\" for command: %{cmdName} in file: %{fn}",
     e_RequireFullName     = [==[Module "%{sn}" must be loaded with the version specified, e.g. "module load %{fullName}". Use

   $ module spider %{sn}

for available versions.]==],
     e_Sh_Error            = [==[Error found in sourcing script "%{script}": %{errorMsg}
If this is a bash script please try:
  $ set -exv; . %{script}
See https://lmod.readthedocs.io/en/latest/260_sh_to_modulefile.html for details.
]==],
     e_Sh_convertSh2MF     = "convertSh2MF script failed to produce 7 blocks\n",
     e_Spdr_Timeout        = "Spider search timed out.\n",
     e_SU_defaults         = "Internal error in setting SU defaults\n",
     e_Swap_Failed         = "Swap failed: \"%{name}\" is not loaded.\n",
     e_Unable_2_Load       = "Unable to load module because of error when evaluating modulefile: %{name}\n     %{fn}: %{message}\n     Please check the modulefile and especially if there is a line number specified in the above message",
     e_Unable_2_Load_short = "%{message}",
     e_Unable_2_parse      = "Unable to parse: \"%{path}\". Aborting!\n",
     e_Unable_2_rename     = "Unable to rename %{from} to %{to}, error message: %{errMsg}",
     e_Unknown_Coll        = "User module collection: \"%{collection}\" does not exist.\n  Try \"module savelist\" for possible choices.\n",
     e_Unknown_key         = "This is an unknown key: \"%{key}\" for the %{func} function",
     e_Unknown_v_type      = "This is an unknown value type: \"%{tkind}\".  The value type should be: \"%{kind}\" for key: \"%{key}\" for the %{func} function",
     e_Unknown_value       = "This is an unknown value: \"%{value} \". for key: \"%{key}\" in the %{func} function",
     e_bad_arg             = "Found arg = \"%{arg}\", expected arg to be of type: %{expected} in file: %{fn} from command: %{cmdName}",
     e_coll_corrupt        = "The module collection file is corrupt. Please remove: %{fn}\n",
     e_dbT_sn_fail         = "dbT[sn] failed for sn: %{sn}\n",
     e_missing_table       = "sandbox_registration: The argument passed is: \"%{kind}\". It should be a table.",
     e_setStandardPaths    = "Unknown Key: \"%{key}\" in setStandardPaths.\n",
     e_wrong_num_args      = "Wrong number of arguments (n: %{n}) for %{cmdName} in file: %{fn}",

     -- Add new error messages for mode selector
     e_Mode_Not_Set        = [==[Syntax error in file: %{fn}
 with command: %{cmdName}, mode must be specified when using mode selector.]==],
     e_Invalid_Mode        = [==[Syntax error in file: %{fn}
 with command: %{cmdName}, invalid mode "%{mode}". Valid modes are: "load" and "unload".]==],
     e_Forbidden_Env       = "MODULEPATH variable cannot be mode selected.",
     e_Invalid_Func_Key    = "Invalid key detected in function %{cmdName}: %{detail}.",

     --------------------------------------------------------------------------
     -- LmodMessages
     --------------------------------------------------------------------------
     m_Activate_Modules    = "\nActivating Modules:\n",
     m_Additional_Variants = "\n    Additional variants of this module can also be loaded after loading the following modules:\n",
     m_Collection_disable  = "Disabling %{name} collection by renaming with a \"~\"\n",
     m_Depend_Mods         = "\n    You will need to load all module(s) on any one of the lines below before the \"%{fullName}\" module is available to load.\n",
     m_Description         = "    Description:\n%{descript}\n\n",
     m_Direct_Load         = "\n    This module can be loaded directly: module load %{fullName}\n",
     m_Extensions_head     = "This is a list of module extensions. Use \"module --nx avail ...\" to not show extensions.",
     m_Extensions_tail     = "\nThese extensions cannot be loaded directly, use \"module spider extension_name\" for more information.\n",
     m_Family_Swap         = "\nLmod is automatically replacing \"%{oldFullName}\" with \"%{newFullName}\".\n",
     m_For_System          = ", for system: \"%{sname}\"",
     m_Hidden_loaded       = "\nOne or more modules are hidden from list. To see all do \"module --show_hidden list\"",
     m_Inactive_Modules    = "\nInactive Modules:\n",
     m_IsNVV               = [==[
Module defaults are chosen based on Find First Rules due to Name/Version/Version modules found in the module tree.
See https://lmod.readthedocs.io/en/latest/060_locating.html for details.
]==],
     m_Global_Alias_na     = "Alias cannot be loaded with current $MODULEPATH",
     m_ModProvides         = "\n    This module provides the following extensions:\n",
     m_Module_Msgs         = [==[
%{border}
There are messages associated with the following module(s):
%{border}
]==],
     m_No_Named_Coll       = "No named collections.\n",
     m_No_Search_Cmd       = [==[The command "module search" does not exist. To list all possible modules execute:

  $   module spider %{s}

To search the contents of modules for matching words execute:

  $   module keyword %{s}
]==], --
     m_Module_Msgs_close   = "%{border}\n\n",
     m_Other_matches       = "\n     Other possible modules matches:\n        %{bb}\n",
     m_Other_possible      = [==[
     Other possible modules matches:
        %{b}
]==],
     m_Properties          = "    Properties:\n",
     m_ProvidedBy          = "Names marked by a trailing (E) are extensions provided by another module.\n\n",
     m_ProvidedFrom        = "    This extension is provided by the following modules. To access the extension you must load one of the following modules. Note that any module names in parentheses show the module location in the software hierarchy.\n\n",
     m_ProvByModules       = "\n   The %{fullName} package is provide by the following modules\n",
     m_Regex_Spider        = [==[%{border}  To find other possible module matches execute:

      $ module -r spider '.*%{name}.*'

]==], --
     m_Reload_Modules      = "\nDue to MODULEPATH changes, the following have been reloaded:\n",
     m_Reload_Version_Chng = "\nThe following have been reloaded with a version change:\n", --
     m_Restore_Coll        = "Restoring modules from %{msg}\n",
     m_Reset_SysDflt       = "Running \"module reset\". Resetting modules to system default. The following $MODULEPATH directories have been removed: %{pathA}\n",
     m_Save_Coll           = "Saved current collection of modules to: \"%{a}\"%{msgTail}\n",
     m_Spdr_L1             = [==[%{border}  For detailed information about a specific "%{key}" package (including how to load the modules) use the module's full name.
  Note that names that have a trailing (E) are extensions provided by other modules.
  For example:

     $ module spider %{exampleV}
%{border}]==],
     m_Spider_Title        = "The following is a list of the modules and extensions currently available:\n",
     m_Spider_Tail         = [==[%{border}
To learn more about a package execute:

   $ module spider Foo

where "Foo" is the name of a module.

To find detailed information about a particular package you
must specify the version if there is more than one version:

   $ module spider Foo/11.1

%{border}]==],
     m_Sticky_Mods         = [==[The following modules were not unloaded:
  (Use "module --force purge" to unload all):
]==],
     m_Sticky_Unstuck      = "\nThe following sticky modules could not be reloaded:\n",
     m_Unload_unknown      = "\nNote: the module \"%{modName}\" cannot be unloaded because it was not loaded.\n",
     m_Versions            = "     Versions:\n",
     m_Where               = "\n  Where:\n",


     --------------------------------------------------------------------------
     -- LmodWarnings
     --------------------------------------------------------------------------
     w_Broken_Cache        = "%{kind} Spider cache appears broken",
     w_Broken_Coll         = [==[One or more modules in your %{collectionName} collection have changed: "%{module_list}".
To see the contents of this collection execute:
  $ module describe %{collectionName}
To rebuild the collection, do a module reset, then load the modules you wish, then execute:
  $ module save %{collectionName}
If you no longer want this module collection execute:
  $ rm ~/.lmod.d/%{collectionName}

For more information execute 'module help' or see https://lmod.readthedocs.org/
No change in modules loaded.

]==],
     w_Broken_FullName     = "Badly formed module-version line: module-name must be fully qualified: %{fullName} is not.\n",
     w_Empty_Coll          = "You have no modules loaded because the collection \"%{collectionName}\" is empty!\n",
     w_MissingModules      = [==[
%{border}
The following dependent module(s) are not currently loaded: %{missing}
%{border}
]==],
     w_MPATH_Coll          = "The system MODULEPATH has changed: please rebuild your saved collection.\n",
     w_Mods_Not_Loaded     = "The following modules were not loaded: %{module_list}\n\n",
     w_Nearly_Forbidden    = "Access will be denied to this module starting %{after}\n",
     w_Nearly_Forbidden_w_msg = "Access will be denied to this module starting %{after}\n%{literal_msg}",
     w_No_Coll             = "No collection named \"%{collection}\" found.",
     w_No_dot_Coll         = "It is illegal to have a `.' in a collection name.  Please choose another name for: \"%{name}\".",
     w_Possible_Bad_Dir    = "Adding \"%{dir}\" to $MODULEPATH. Did you mean: \"module %{dir} use\"?",
     w_SYS_DFLT_EMPTY      = [==[
The system default contains no modules
  (env var: LMOD_SYSTEM_DEFAULT_MODULES is empty)
  No changes in loaded modules

]==],
     w_Save_Empty_Coll     = [==[You are trying to save an empty collection of modules in "%{name}". If this is what you want then enter:
  $  module --force save %{name}
]==], --
     w_System_Reserved     = "The named collection 'system' is reserved. Please choose another name.\n",
     w_Too_Many_RegularFn  = [==[
MODULEPATH directory: "%{mpath}" has too many non-modulefiles (%{regularFn}). Please make sure that modulefiles are in their own directory and not mixed in with non-modulefiles (e.g. source code)
]==],
     w_Undef_MPATH         = "MODULEPATH is undefined.\n",
     w_Unknown_Hook        = "Unknown hook: %{name}\n",
     w_Unknown_Hook_Action = "Unknown hook action: %{action}\n",


     --------------------------------------------------------------------------
     -- Usage Message
     --------------------------------------------------------------------------
     usage_cmdline         = "module [options] sub-command [args ...]",
     help_title            = "Help sub-commands:\n\n",
     help1                 = "prints this message",
     help2                 = "print help message from module(s)",

     load_title            = "Loading/Unloading sub-commands:\n\n",
     load1                 = "load module(s)",
     load2                 = "Add module(s), do not complain if not found",
     load3                 = "Remove module(s), do not complain if not found",
     load4                 = "unload m1 and load m2",
     load5                 = "unload all modules",
     load6                 = "reload aliases from current list of modules.",
     load7                 = "reload all currently loaded modules.",

     list_title            = "Listing / Searching sub-commands:\n\n",
     list1                 = "List loaded modules",
     list2                 = "List loaded modules that match the pattern",
     list3                 = "List available modules",
     list4                 = "List available modules that contain \"string\".",
     list5                 = "List all possible modules",
     list6                 = "List all possible version of that module file",
     list7                 = "List all module that contain the \"string\".",
     list8                 = "Detailed information about that version of the module.",
     list9                 = "Print whatis information about module",
     list10                = "Search all name and whatis that contain \"string\".",

     ov1                   = "List all available modules by short names with number of versions",
     ov2                   = "List available modules by short names with number of versions that contain \"string\"",

     srch_title            = "Searching with Lmod:\n\n",
     srch0                 = "  All searching (spider, list, avail, keyword) support regular expressions:",
     srch1                 = "Finds all the modules that start with `p' or `P'",
     srch2                 = "Finds all modules that have \"mpi\" in their name.",
     srch3                 = "Finds all modules that end with \"mpi\" in their name.",

     collctn_title         = "Handling a collection of modules:\n\n",
     collctn1              = "Save the current list of modules to a user defined \"default\" collection.",
     collctn2              = "Save the current list of modules to \"name\" collection.",
     collctn3              = "The same as \"restore system\"",
     collctn4              = "Restore modules from the user's \"default\" or system default.",
     collctn5              = "Restore modules from \"name\" collection.",
     collctn6              = "Restore module state to system defaults.",
     collctn7              = "List of saved collections.",
     collctn8              = "Describe the contents of a module collection.",
     collctn9              = "Disable (i.e. remove) a collection.",

     depr_title            = "Deprecated commands:\n\n",
     depr1                 = "load name collection of modules or user's \"default\" if no name given.",
     depr2                 = "===> Use \"restore\" instead  <====",
     depr3                 = "Save current list of modules to name if given, otherwise save as the default list for you the user.",
     depr4                 = "===> Use \"save\" instead. <====",

     misc_title            = "Miscellaneous sub-commands:\n\n",
     misc1                 = "show the commands in the module file.",
     misc2                 = "Prepend or Append path to MODULEPATH.",
     misc3                 = "remove path from MODULEPATH.",
     misc4                 = "output list of active modules as a lua table.",
     misc_isLoaded         = "return a true status if module is loaded",
     misc_isAvail          = "return a true status if module can be loaded",


     env_title             = "Important Environment Variables:\n\n",
     env1                  = "If defined to be \"YES\" then Lmod prints properties and warning in color.",
     web_sites             = "Lmod Web Sites",
     rpt_bug               = "  To report a bug please read ",



     --------------------------------------------------------------------------
     -- module help strings
     --------------------------------------------------------------------------
     StickyM        = "Module is Sticky, requires --force to unload or purge",
     LoadedM        = "Module is loaded",
     ExplM          = "Experimental",
     TstM           = "Testing",
     ObsM           = "Obsolete",

     MT_hlp         = "Report Module Table State",
     avail_hlp      = "List default modules only when used with avail",
     cache_hlp      = "Treat the cache file(s) as out-of-date",
     chkSyn_H       = "Checking module command syntax: do not load",
     config_H       = "Report Lmod Configuration",
     dbg_hlp        = "Program tracing written to stderr",
     dbg_hlp2       = "Program tracing written to stderr (where dbglvl is a number 1,2,3)",
     dumpN_hlp      = "Dump the name Lmod in a machine readable way and quit",
     dumpV_hlp      = "Dump version in a machine readable way and quit",
     exprt_hlp      = "Expert mode",
     force_hlp      = "force removal of a sticky module or save an empty collection",
     gitV_hlp       = "Dump git version in a machine readable way and quit",
     help_hlp       = "This help message",
     hidden_H       = "Avail and spider will report hidden modules",
     initL_hlp      = "loading Lmod for first time in a user shell",
     jcnfig_H       = "Report Lmod Configuration in json format",
     latest_H       = "Load latest (ignore default)",
     location_H     = "Just print the file location when using show ",
     miniConfig_H   = "Report Lmod Configuration differences",
     novice_H       = "Turn off expert and quiet flag",
     nrdirect_H     = "Force output of list, avail and spider to stderr",
     nx_H           = "Do not print extensions",
     pin_hlp        = "When doing a restore use specified version, do not follow defaults",
     pod_H          = "Generate pod format",
     quiet_hlp      = "Do not print out warnings",
     raw_hlp        = "Print modulefile in raw output when used with show",
     redirect_H     = "Send the output of list, avail, spider to stdout (not stderr)",
     rexp_hlp       = "use regular expression match",
     rt_hlp         = "Lmod regression testing",
     spdrT_H        = "a timeout for spider",
     style_hlp      = "Site controlled avail style: %{styleA} (default: %{default})",
     terse_hlp      = "Write out in machine readable format for commands: list, avail, spider, savelist",
     terseShowExt_H = "report extensions when doing a terse avail",
     timer_hlp      = "report run times",
     trace_H        = "trace major changes such as loads",
     v_hlp          = "Print version info and quit",
     width_hlp      = "Use this as max term width",

     Where          = "\n  Where:\n",
     Inactive       = "\nInactive Modules",
     DefaultM       = "Default Module",
     NearlyForbiddenM = "Nearly Forbidden Module",
     ForbiddenM     = "Forbidden Module",
     HiddenM        = "Hidden Module",
     HiddenLoadM    = "Hidden from load Module",
     Hidden_softM   = "Soft Hidden Module",
     Extension      = "Extension that is provided by another module",

     avail     = [==[If the avail list is too long consider trying:

"module --default avail" or "ml -d av"  to just list the default modules.
"module overview" or "ml ov" to display the number of modules for each name.

Use "module spider" to find all possible modules and extensions.
Use "module keyword key1 key2 ..." to search for all possible modules matching any of the "keys".
]==],
     list      = " ",
     spider    = " ",
     aliasMsg  = "Aliases exist: foo/1.2.3 (1.2) means that \"module load foo/1.2\" will load foo/1.2.3",
     noModules = "No module(s) or extension(s) found!",
     noneFound = "  None found.",

     --------------------------------------------------------------------------
     -- Other strings:
     --------------------------------------------------------------------------
     coll_contains  = "Collection \"%{collection}\" contains: \n",
     currLoadedMods = "Currently Loaded Modules",
     keyword_msg    = [==[
%{border}
The following modules match your search criteria: "%{module_list}"
%{border}
]==],
     lmodSystemName = "(For LMOD_SYSTEM_NAME = \"%{name}\")",
     matching       = " Matching: %{wanted}",
     namedCollList  = "Named collection list %{msgHdr}:\n",
     noModsLoaded   = "No modules loaded\n",
     specific_hlp   = "Module Specific Help for \"%{fullName}\"",

   }
}

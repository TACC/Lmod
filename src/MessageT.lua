local messageT = {
   --------------------------------------------------------------------------
   -- LmodError messages
   --------------------------------------------------------------------------
   e_No_Hashsum = "Unable to find HashSum program (sha1sum, shasum, md5sum or md5)",
   e_Unable_2_parse = "Unable to parse: \"%{path}\". Aborting!\n",
   e_LocationT_Srch = "Error in LocationT:search()",
   e_No_Mod_Entry = "%{routine}: Did not find module entry: \"%{name}\". This should not happen!\n",
   e_No_PropT_Entry = "%{routine}: system property table has no %{location} for: \"%{name}\". \nCheck spelling and case of name.\n",
   e_No_ValidT_Entry = "%{routine}: The validT table for %{name} has no entry for: \"%{value}\". \nCheck spelling and case of name.\n",
   e_Failed_2_Find = "Unable to find: \"%{name}\"\n",
   e_Failed_2_Inherit = "Failed to inherit: %{name}\n",
   e_No_AutoSwap = [==[Your site prevents the automatic swapping of modules with same name. You must explicitly unload the loaded version of "%{oldFullName}" before you can load the new one. Use swap to do this:

   $ module swap %{oldFullName} %{newFullName}

Alternatively, you can set the environment variable LMOD_DISABLE_SAME_NAME_AUTOSWAP to "no" to re-enable same name autoswapping.
]==],
   e_Avail_No_MPATH = "module avail is not possible. MODULEPATH is not set or not set with valid paths.\n",
   e_Missing_Value = "%{func}(\"%{name}\") is not valid, a value is required",
   e_Conflict = "Cannot load module \"%{name}\" because these module(s) are loaded:\n   %{module_list}\n",
   e_Prereq = "Cannot load module \"%{name}\" without these module(s) loaded:\n   %{module_list}\n",
   e_Prereq_Any = "Cannot load module \"%{name}\". At least one of these module(s) must be loaded:\n   %{module_list}\n",
   e_Family_Conflict = [==[You can only have one %{name} module loaded at a time.
You already have %{oldName} loaded.
To correct the situation, please enter the following command:

  $  module swap %{oldName} %{fullName}

Please submit a consulting ticket if you require additional assistance.
]==],
   e_setStandardPaths = "Unknown Key: \"%{key}\" in setStandardPaths\n",
   e_No_Matching_Mods = "No matching modules found\n",
   e_Unknown_Coll = "User module collection: \"%{collection}\" does not exist.\n  Try \"module savelist\" for possible choices.\n",
   e_No_Period_Allowed = "Collection names cannot have a `.' in the name.\n  Please rename \"%collection}\"\n",
   e_Swap_Failed = "Swap failed: \"%{name}\" is not loaded.\n",
   e_Unable_2_Load = "Unable to load module: %{name}\n     %{fn}: %{message}\n",
   e_missing_table = "sandbox_registration: The argument passed is: \"%{kind}\". It should be a table.",
   e_No_UUID = "uuidgen is not available, fallback failed too",
   e_Spdr_Timeout = "Spider searched timed out\n",
   e_dbT_sn_fail = "dbT[sn] failed for sn: %{sn}\n",
   e_Failed_Hashsum = "Unable to compute hashsum\n",

   --------------------------------------------------------------------------
   -- LmodMessages
   --------------------------------------------------------------------------
   m_Family_Swap = "\nLmod is automatically replacing \"%{oldFullName}\" with \"%{newFullName}\"\n",
   
   --------------------------------------------------------------------------
   -- LmodWarnings
   --------------------------------------------------------------------------
   w_Broken_Coll = [==[One or more modules in your %{collectionName} collection have changed: "%{module_list}".

To see the contents of this collection do:
  $ module describe %{collectionName}
To forcibly load this collection without the changed modules do:
  $ module restore %{collectionName} --force
To rebuild the collection, load the modules you wish then do:
  $ module save %{collectionName}
If you no longer want this module collection do:
  $ rm ~/.lmod.d/%{collectionName}

For more information execute 'module help' or see http://lmod.readthedocs.org/
No change in modules loaded

]==],
   w_Missing_Coll = [==[One or more modules in your %{collectionName} collection are missing: "%{module_list}".

To see the contents of this collection do:
  $ module describe %{collectionName}
To forcibly load this collection without the missing modules do:
  $ module restore %{collectionName} --force
To rebuild the collection, load the modules you wish then do:
  $ module save %{collectionName}
If you no longer want this module collection do:
  $ rm ~/.lmod.d/%{collectionName}

For more information execute 'module help' or see http://lmod.readthedocs.org/
No change in modules loaded

]==],
   w_Broken_Coll_Forced = [==[Forcibly loading collection %{collectionName} despite changed modules: "%{module_list}".

To see the contents of this collection do:
  $ module describe %{collectionName}
To rebuild the collection, load the modules you wish then do:
  $ module save %{collectionName}
If you no longer want this module collection do:
  $ rm ~/.lmod.d/%{collectionName}

For more information execute 'module help' or see http://lmod.readthedocs.org/

]==],
   w_Missing_Coll_Forced = [==[Forcibly loading collection %{collectionName} despite missing modules: "%{module_list}".

To see the contents of this collection do:
  $ module describe %{collectionName}
To rebuild the collection, load the modules you wish then do:
  $ module save %{collectionName}
If you no longer want this module collection do:
  $ rm ~/.lmod.d/%{collectionName}

For more information execute 'module help' or see http://lmod.readthedocs.org/

]==],
   w_Broken_FullName = "Badly formed module-version line: module-name must be fully qualified: %{fullName} is not\n",
   w_MPATH_Coll = "The system MODULEPATH has changed: Please rebuild your saved collection.\n",
   w_Empty_Coll = "You have no modules loaded because the collection \"%{collectionName}\" is empty!\n",
   w_Mods_Not_Loaded = "The following modules were not loaded: %{module_list}\n\n",
   w_No_Coll = "No collection named \"%{collection}\" found.",
   w_Undef_MPATH = "MODULEPATH is undefined\n",
   w_No_dot_Coll = "It is illegal to have a `.' in a collection name.  Please choose another name for: %{name}",
   w_System_Reserved = "The named collection 'system' is reserved. Please choose another name.\n",
   w_Save_Empty_Coll = [==[You are trying to save an empty collection of modules in "%{name}". If this is what you want then enter:
  $  module --force save %{name}
]==],
}


return messageT

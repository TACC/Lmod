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
   e114 = "Cannot load module \"%{name}\". At least one of these module(s) must be loaded:\n   %{module_list}\n",
   e115 = [==[You can only have one %{name} module loaded at a time.
You already have %{oldName} loaded.
To correct the situation, please enter the following command:

  $  module swap %{oldName} %{fullName}

Please submit a consulting ticket if you require additional assistance.
]==],
   e116 = "Unknown Key: \"%{key}\" in setStandardPaths\n",
   e117 = "No matching modules found\n",
   e118 = "User module collection: \"%{collection}\" does not exist.\n  Try \"module savelist\" for possible choices.\n",
   e119 = "Collection names cannot have a `.' in the name.\n  Please rename \"%collection}\"\n",
   e120 = "Swap failed: \"%{name}\" is not loaded.\n",
   e121 = "Unable to load module: %{name}\n     %{fn}: %{message}\n",
   e122 = "sandbox_registration: The argument passed is: \"%{kind}\". It should be a table.",
   e123 = "uuidgen is not available, fallback failed too",
   e124 = "Spider searched timed out\n",
   e125 = "dbT[sn] failed for sn: %{sn}\n",
   e126 = "Unable to compute hashsum\n",

   --------------------------------------------------------------------------
   -- LmodMessages
   --------------------------------------------------------------------------
   m401 = "\nLmod is automatically replacing \"%{oldFullName}\" with \"%{newFullName}\"\n",
   
   --------------------------------------------------------------------------
   -- LmodWarnings
   --------------------------------------------------------------------------
   w501 = [==[One or more modules in your %{collectionName} collection have changed: "%{module_list}".
To see the contents of this collection do:
  $ module describe %{collectionName}
To rebuild the collection, load the modules you wish then do:
  $ module save %{collectionName}
If you no longer want this module collection do:
  $ rm ~/.lmod.d/%{collectionName}

For more information execute 'module help' or see http://lmod.readthedocs.org/
No change in modules loaded

]==],
   w502 = "Badly formed module-version line: module-name must be fully qualified: %{fullName} is not\n",
   w503 = "The system MODULEPATH has changed: Please rebuild your saved collection.\n",
   w504 = "You have no modules loaded because the collection \"%{collectionName}\" is empty!\n",
   w505 = "The following modules were not loaded: %{module_list}\n\n",
   w506 = "No collection named \"%{collection}\" found.",
   w507 = "MODULEPATH is undefined\n",
   w508 = "It is illegal to have a `.' in a collection name.  Please choose another name for: %{name}",
   w509 = "The named collection 'system' is reserved. Please choose another name.\n",
   w510 = [==[You are trying to save an empty collection of modules in "%{name}". If this is what you want then enter:
  $  module --force save %{name}
]==],
}


return messageT

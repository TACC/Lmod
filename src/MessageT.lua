local messageT = {
   m101 = "\nLmod is automatically replacing \"%{oldFullName}\" with \"%{newFullName}\"\n",

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

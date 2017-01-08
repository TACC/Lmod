return {
   es = {
     errTitle  = "Lmod ha detectado el siguiente error: ",
     warnTitle = "Lmod Warning: ",
     --------------------------------------------------------------------------
     -- LmodError messages
     --------------------------------------------------------------------------
     e101 = "Imposible encontrar un programa HashSum (sha1sum, shasum, md5sum o md5)",
     e102 = "Imposible analizar: \"%{path}\". ¡Abortar!\n",
     e103 = "Error in LocationT:search()",
     e104 = "%{routine}: No se encontró la entrada al módulo: \"%{name}\". ¡Esto no debería suceder!\n",
     e105 = "%{routine}: la tabla de propiedades del system no tiene %{location} para: \"%{name}\". \nCompruebe la ortografía, así como mayúsculas y minúsculas.\n",
     e106 = "%{routine}: La tabla validT para %{name} no contiene registros para: \"%{value}\". \nCompruebe la ortografía, así como mayúsculas y minúsculas\n",
     e107 = "Imposible encontrar: \"%{name}\"\n",
     e108 = "Error al heredar: %{name}\n",
     e109 = [==[Su sistema impide el intercambio automático de módulos con el mismo nombre. Debe descargar primero "%{oldFullName}" antes de poder cargar la nueva versión. Use swap para hacer esto:

   $ module swap %{oldFullName} %{newFullName}

Además, puede configurar la variable de entorno LMOD_DISABLE_SAME_NAME_AUTOSWAP con el valor "no"  para habilitar al intercambio automático de módulos con el mismo nombre.
]==],
     e110 = "No es posible ejecutar 'module avail'. MODULEPATH no está inicializado o su valor no contiene rutas correctas.\n",
     e111 = "%{func}(\"%{name}\") no es válido, es necesario un valor",
     e112 = "Imposible cargar el módulo \"%{name}\" porque este (estos) módulo(s) está(n) cargado(s):\n   %{module_list}\n",
     e113 = "Imposible cargar el módulo \"%{name}\" sin cargar antes:\n   %{module_list}\n",
     e114 = "Imposible cargar el módulo \"%{name}\". Al menos uno de estos módulos debe ser cargado anteriormente:\n   %{module_list}\n",
     e115 = [==[Sólo puede tener un módulo %{name} cargado a la vez.
Ya tiene %{oldName} cargado.
Para solucionar esta situación, introduzca el siguiente comando:

  $  module swap %{oldName} %{fullName}

Por favor, envíe un ticket si necesita más ayuda.
]==],
     e116 = "Elemento desconocido: \"%{key}\" en setStandardPaths\n",
     e117 = "No se encontraron módulos que coincidan.\n",
     e118 = "La colección: \"%{collection}\" no existe.\n  Intente \"module savelist\" para ver posibles opciones.\n",
     e119 = "Los nombres de colecciones no pueden contener un `.' .\n  Por favor elimine \"%collection}\"\n",
     e120 = "Falló el intercambio: \"%{name}\" no está cargado.\n",
     e121 = "Imposible cargar el módulo: %{name}\n     %{fn}: %{message}\n",
     e122 = "sandbox_registration: El argumento pasado es: \"%{kind}\". Debería ser una tabla.",
     e123 = "uuidgen no está disponible y la alternativa también falló",
     e124 = "La búsqueda de Spider expiró\n",
     e125 = "dbT[sn] falló por sn: %{sn}\n",
     e126 = "Imposible calcular hashsum\n",

     --------------------------------------------------------------------------
     -- LmodMessages
     --------------------------------------------------------------------------
     m401 = "\nLmod va a reemplazar \"%{oldFullName}\" con \"%{newFullName}\" automáticamente\n",
     
     --------------------------------------------------------------------------
     -- LmodWarnings
     --------------------------------------------------------------------------
     w501 = [==[Uno o más de los módulos en la colección %{collectionName} ha cambiado: "%{module_list}".
Para ver los elementos de esta colección, pruebe:
  $ module describe %{collectionName}
Para regenerar la colección, cargue los módulos que desee y luego ejecute:
  $ module save %{collectionName}
Si quiere eliminar esta colección, ejecute:
  $ rm ~/.lmod.d/%{collectionName}

Para más información, ejecute 'module help' o visite http://lmod.readthedocs.org/
No ha habido ningún cambio en los módulos cargados

]==],
     w502 = "module-version es incorrecto: module-name debe estar totalmente descrito: %{fullName} no lo está\n",
     w503 = "El sistema MODULEPATH ha cambiado: por favor, reconstruya su colección.\n",
     w504 = "¡No tiene módulos cargados porque la colección \"%{collectionName}\" está vacía!\n",
     w505 = "Los siguientes módulos no fueron cargados: %{module_list}\n\n",
     w506 = "No se encontró una colección con el nombre \"%{collection}\" .",
     w507 = "MODULEPATH no está definido\n",
     w508 = "Es ilegal usar un `.' en el nombre de una colección. Por favor, elija otro nombre para: %{name}",
     w509 = "El nombre 'system' es un nombre reservado. Por favor, elija otro nombre.\n",
     w510 = [==[Está intentando guardar una colección vacía en "%{name}". Si esto es lo que realmente desea hacer, entonces ejecute lo siguiente:
  $  module --force save %{name}
]==],
   }
}

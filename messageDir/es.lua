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
   es = {
     errTitle  = "Lmod ha detectado el siguiente error: ",
     warnTitle = "Lmod Warning: ",
     --------------------------------------------------------------------------
     -- LmodError messages
     --------------------------------------------------------------------------
     e_No_Hashsum = "Imposible encontrar un programa HashSum (sha1sum, shasum, md5sum o md5)",
     e_Unable_2_parse = "Imposible analizar: \"%{path}\". ¡Abortar!\n",
     e_LocationT_Srch = "Error in LocationT:search()",
     e_No_Mod_Entry = "%{routine}: No se encontró la entrada al módulo: \"%{name}\". ¡Esto no debería suceder!\n",
     e_No_PropT_Entry = "%{routine}: la tabla de propiedades del system no tiene %{location} para: \"%{name}\". \nCompruebe la ortografía, así como mayúsculas y minúsculas.\n",
     e_No_ValidT_Entry = "%{routine}: La tabla validT para %{name} no contiene registros para: \"%{value}\". \nCompruebe la ortografía, así como mayúsculas y minúsculas\n",
     e_Failed_2_Find = "Imposible encontrar: \"%{name}\"\n",
     e_Failed_2_Inherit = "Error al heredar: %{name}\n",
     e_No_AutoSwap = [==[Su sistema impide el intercambio automático de módulos con el mismo nombre. Debe descargar primero "%{oldFullName}" antes de poder cargar la nueva versión. Use swap para hacer esto:

   $ module swap %{oldFullName} %{newFullName}

Además, puede configurar la variable de entorno LMOD_DISABLE_SAME_NAME_AUTOSWAP con el valor "no"  para habilitar al intercambio automático de módulos con el mismo nombre.
]==],
     e_Avail_No_MPATH = "No es posible ejecutar 'module avail'. MODULEPATH no está inicializado o su valor no contiene rutas correctas.\n",
     e_Missing_Value = "%{func}(\"%{name}\") no es válido, es necesario un valor",
     e_Conflict = "Imposible cargar el módulo \"%{name}\" porque este (estos) módulo(s) está(n) cargado(s):\n   %{module_list}\n",
     e_Prereq = "Imposible cargar el módulo \"%{name}\" sin cargar antes:\n   %{module_list}\n",
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
     e127 = [==[Los siguientes módulos son desconocidos: %{module_list}

Por favor compruebe la ortografía, así como mayúsculas y minúsculas o número de versión. También intente "module spider ..."
También es posible que su archivo de cache estea desactualizado. Intente:
  $   module --ignore-cache load %{module_list} 
]==],
     e128 = [==[Estos módulos existen pero no pueden ser cargados como ha solicitado: %{kA}
   Intente: "module spider %{kB}" para ver como cargar los módulos.
]==],

     e129 = [==[Error de sintaxis en el archivo: %{fn}
 con el comando: %{cmdName}, uno o más argumentos no son cadenas de caracteres.
]==],
     e130 = [==[Error de sintaxis en el archivo: %{fn}
con el comando: "execute".
La sintaxis es:
    execute{cmd="command string",modeA={"load",...}}
]==],
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

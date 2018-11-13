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
   es = {
     --------------------------------------------------------------------------
     -- Error/Warning Titles
     --------------------------------------------------------------------------
     errTitle  = "Lmod ha detectado el siguiente error: ",
     warnTitle = "Lmod Warning: ",

     --------------------------------------------------------------------------
     -- ml messages
     --------------------------------------------------------------------------

     ml_help               = nil,
     ml_opt                = nil,
     ml_2many              = nil,
     ml_misplaced_opt      = nil,
     

     --------------------------------------------------------------------------
     -- LmodError messages
     --------------------------------------------------------------------------
     e_Args_Not_Strings    = [==[Error de sintaxis en el archivo: %{fn}
 con el comando: %{cmdName}, uno o más argumentos no son cadenas de caracteres.
]==],
     e_Avail_No_MPATH      = "No es posible ejecutar 'module avail'. MODULEPATH no está inicializado o su valor no contiene rutas correctas.\n",
     e_BrokenCacheFn       = nil,
     e_BrokenQ             = nil,
     e_Conflict            = "Imposible cargar el módulo \"%{name}\" porque este (estos) módulo(s) está(n) cargado(s):\n   %{module_list}\n",
     e_Execute_Msg         = [==[Error de sintaxis en el archivo: %{fn}
con el comando: "execute".
La sintaxis es:
    execute{cmd = "command string",modeA={"load",...}}
]==],
     e_Failed_2_Find       = "Imposible encontrar: \"%{name}\"\n",
     e_Failed_2_Inherit    = "Error al heredar: %{name}\n",
     e_Failed_Hashsum      = "Imposible calcular hashsum\n",
     e_Failed_Load         = [==[Los siguientes módulos son desconocidos: %{module_list}

Por favor compruebe la ortografía, así como mayúsculas y minúsculas o número de versión. También intente "module spider ..."
También es posible que su archivo de cache estea desactualizado. Intente:
  $   module --ignore-cache load %{module_list} 
]==],
     e_Failed_Load_2       = [==[Estos módulos existen pero no pueden ser cargados como ha solicitado: %{kA}
   Intente: "module spider %{kB}" para ver como cargar los módulos.
]==],
     e_Family_Conflict     = [==[Sólo puede tener un módulo %{name} cargado a la vez.
Ya tiene %{oldName} cargado.
Para solucionar esta situación, introduzca el siguiente comando:

  $  module swap %{oldName} %{fullName}

Por favor, envíe un ticket si necesita más ayuda.
]==],
     e_Illegal_Load        = nil,
     e_LocationT_Srch      = "Error in LocationT:search()",
     e_Missing_Value       = "%{func}(\"%{name}\") no es válido, es necesario un valor",
     e_MT_corrupt          = nil,
     e_No_AutoSwap         = [==[Su sistema impide el intercambio automático de módulos con el mismo nombre. Debe descargar primero "%{oldFullName}" antes de poder cargar la nueva versión. Use swap para hacer esto:

   $ module swap %{oldFullName} %{newFullName}

Además, puede configurar la variable de entorno LMOD_DISABLE_SAME_NAME_AUTOSWAP con el valor "no"  para habilitar al intercambio automático de módulos con el mismo nombre.
]==], -- 
     e_No_Hashsum          = "Imposible encontrar un programa HashSum (sha1sum, shasum, md5sum o md5)",
     e_No_Matching_Mods    = "No se encontraron módulos que coincidan.\n",
     e_No_Mod_Entry        = "%{routine}: No se encontró la entrada al módulo: \"%{name}\". ¡Esto no debería suceder!\n",
     e_No_Period_Allowed   = "Los nombres de colecciones no pueden contener un `.' .\n  Por favor elimine \"%collection}\"\n",
     e_No_PropT_Entry      = "%{routine}: la tabla de propiedades del system no tiene %{location} para: \"%{name}\". \nCompruebe la ortografía, así como mayúsculas y minúsculas.\n",
     e_No_UUID             = "uuidgen no está disponible y la alternativa también falló",
     e_No_ValidT_Entry     = "%{routine}: La tabla validT para %{name} no contiene registros para: \"%{value}\". \nCompruebe la ortografía, así como mayúsculas y minúsculas\n",
     e_Prereq              = "Imposible cargar el módulo \"%{name}\" sin cargar antes:\n   %{module_list}\n",
     e_Prereq_Any          = "Imposible cargar el módulo \"%{name}\". Al menos uno de estos módulos debe ser cargado anteriormente:\n   %{module_list}\n",
     e_Spdr_Timeout        = "La búsqueda de Spider expiró\n",
     e_Swap_Failed         = "Falló el intercambio: \"%{name}\" no está cargado.\n",
     w_SYS_DFLT_EMPTY      = nil,
     e_Unable_2_Load       = "Imposible cargar el módulo: %{name}\n     %{fn}: %{message}\n",
     e_Unable_2_parse      = "Imposible analizar: \"%{path}\". ¡Abortar!\n",
     e_Unable_2_rename     = nil,
     e_Unknown_Coll        = "La colección: \"%{collection}\" no existe.\n  Intente \"module savelist\" para ver posibles opciones.\n",
     e_coll_corrupt        = nil,
     e_dbT_sn_fail         = "dbT[sn] falló por sn: %{sn}\n",
     e_missing_table       = "sandbox_registration: El argumento pasado es: \"%{kind}\". Debería ser una tabla.",
     e_setStandardPaths    = "Elemento desconocido: \"%{key}\" en setStandardPaths\n",

     --------------------------------------------------------------------------
     -- LmodMessages
     --------------------------------------------------------------------------
     m_Activate_Modules    = nil,
     m_Additional_Variants = nil,
     m_Collection_disable  = nil,
     m_Depend_Mods         = nil,
     m_Description         = nil,
     m_Direct_Load         = nil,
     m_Family_Swap         = "\nLmod va a reemplazar \"%{oldFullName}\" con \"%{newFullName}\" automáticamente\n",
     m_For_System          = nil,
     m_Inactive_Modules    = nil,
     m_IsNVV               = nil,
     m_Module_Msgs         = nil,
     m_No_Named_Coll       = nil,
     m_No_Search_Cmd       = nil,
     m_Other_matches       = nil,
     m_Other_possible      = nil,
     m_Properties          = nil,
     m_Regex_Spider        = nil,
     m_Reload_Modules      = nil,
     m_Reload_Version_Chng = nil,
     m_Restore_Coll        = nil,
     m_Reset_SysDflt       = nil,
     m_Save_Coll           = nil,
     m_Spdr_L1             = nil,
     m_Spider_Title        = nil,
     m_Spider_Tail         = nil,
     m_Sticky_Mods         = nil,
     m_Sticky_Unstuck      = nil,
     m_Versions            = nil,
     m_Where               = nil,
     
     --------------------------------------------------------------------------
     -- LmodWarnings
     --------------------------------------------------------------------------
     w_Broken_Coll         = [==[Uno o más de los módulos en la colección %{collectionName} ha cambiado: "%{module_list}".
Para ver los elementos de esta colección, pruebe:
  $ module describe %{collectionName}
Para regenerar la colección, cargue los módulos que desee y luego ejecute:
  $ module save %{collectionName}
Si quiere eliminar esta colección, ejecute:
  $ rm ~/.lmod.d/%{collectionName}

Para más información, ejecute 'module help' o visite http://lmod.readthedocs.org/
No ha habido ningún cambio en los módulos cargados

]==],
     w_Broken_FullName     = "module-version es incorrecto: module-name debe estar totalmente descrito: %{fullName} no lo está\n",
     w_Empty_Coll          = "¡No tiene módulos cargados porque la colección \"%{collectionName}\" está vacía!\n",
     w_Failed_2_Find       = nil,
     w_MissingModules      = nil,
     w_MPATH_Coll          = "El sistema MODULEPATH ha cambiado: por favor, reconstruya su colección.\n",
     w_Mods_Not_Loaded     = "Los siguientes módulos no fueron cargados: %{module_list}\n\n",
     w_No_Coll             = "No se encontró una colección con el nombre \"%{collection}\" .",
     w_No_dot_Coll         = "Es ilegal usar un `.' en el nombre de una colección. Por favor, elija otro nombre para: %{name}",
     w_Save_Empty_Coll     = [==[Está intentando guardar una colección vacía en "%{name}". Si esto es lo que realmente desea hacer, entonces ejecute lo siguiente:
  $  module --force save %{name}
]==],
     w_SYS_DFLT_EMPTY      = nil,
     w_System_Reserved     = "El nombre 'system' es un nombre reservado. Por favor, elija otro nombre.\n",
     w_Undef_MPATH         = "MODULEPATH no está definido\n",
     w_Unknown_Hook        = nil,

     --------------------------------------------------------------------------
     -- Usage Message
     --------------------------------------------------------------------------
     usage_cmdline         = nil,
     help_title            = nil,
     help1                 = nil,
     help2                 = nil,

     load_title            = nil,
     load1                 = nil,
     load2                 = nil,
     load3                 = nil,
     load4                 = nil,
     load5                 = nil,
     load6                 = nil,
     load7                 = nil,

     list_title            = nil,
     list1                 = nil,
     list2                 = nil,
     list3                 = nil,
     list4                 = nil,
     list5                 = nil,
     list6                 = nil,
     list7                 = nil,
     list8                 = nil,
     list9                 = nil,
     list10                = nil,

     srch_title            = nil,
     srch0                 = nil,
     srch1                 = nil,
     srch2                 = nil,
     srch3                 = nil,

     collctn_title         = nil,
     collctn1              = nil,
     collctn2              = nil,
     collctn3              = nil,
     collctn4              = nil,
     collctn5              = nil,
     collctn6              = nil,
     collctn7              = nil,
     collctn8              = nil,
     collctn9              = nil,

     depr_title            = nil,
     depr1                 = nil,
     depr2                 = nil,
     depr3                 = nil,
     depr4                 = nil,

     misc_title            = nil,
     misc1                 = nil,
     misc2                 = nil,
     misc3                 = nil,
     misc4                 = nil,


     env_title             = nil,
     env1                  = nil,
     web_sites             = nil,
     rpt_bug               = nil,

     --------------------------------------------------------------------------
     -- module help strings
     --------------------------------------------------------------------------


     StickyM   = nil,
     LoadedM   = nil,
     ExplM     = nil,
     TstM      = nil,
     ObsM      = nil,

     help_hlp  = nil,
     style_hlp = nil,
     rt_hlp    = nil,
     dbg_hlp   = nil,
     pin_hlp   = nil,
     avail_hlp = nil,
     quiet_hlp = nil,
     exprt_hlp = nil,
     terse_hlp = nil,
     initL_hlp = nil,
     latest_H  = nil,
     cache_hlp = nil,
     novice_H  = nil,
     raw_hlp   = nil,
     width_hlp = nil,
     v_hlp     = nil,
     rexp_hlp  = nil,
     gitV_hlp  = nil,
     dumpV_hlp = nil,
     chkSyn_H  = nil,
     config_H  = nil,
     jcnfig_H  = nil,
     MT_hlp    = nil,
     timer_hlp = nil,
     force_hlp = nil,
     redirect_H= nil,
     nrdirect_H= nil,
     hidden_H  = nil,
     spdrT_H   = nil,
     trace_T   = nil,

     Where     = nil,
     Inactive  = nil,
     DefaultM  = nil,
     HiddenM   = nil,

     avail     = nil,
     list      = nil,
     spider    = nil,
     aliasMsg  = nil,
     noModules = nil,
     noneFound = nil,

     --------------------------------------------------------------------------
     -- Other strings:
     --------------------------------------------------------------------------
     coll_contains  = nil,
     currLoadedMods = nil,
     keyword_msg    = nil,
     lmodSystemName = nil,
     matching       = nil,
     namedCollList  = nil,
     noModsLoaded   = nil,
     specific_hlp   = nil,

   }
}

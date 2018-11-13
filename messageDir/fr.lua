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
   fr = {

     --------------------------------------------------------------------------
     -- Error/Warning Titles
     --------------------------------------------------------------------------
     errTitle  = "Lmod a détecté l'erreur suivante : ",
     warnTitle = "Lmod Warning: ",

     --------------------------------------------------------------------------
     -- ml messages
     --------------------------------------------------------------------------

     ml_help   = [==[
   ml: Une interface pratique pour la commande module : 

   Utilisation simplifiée :
   ------------------------
     $ ml
                              signifie: module list
     $ ml foo bar
                              signifie: module load foo bar
     $ ml -foo -bar baz goo
                              signifie: module unload foo bar;
                                     module load baz goo;

   Utilisation détaillée :
   -----------------------

   N'importe quelle commande de module peut être ajoutée après ml : 

   si le nom est is avail, save, restore, show, swap,...
       $ ml nom  arg1 arg2 ...

   Alors le résultat est le même que : 
       $ module nom arg1 arg2 ...

   Autrement dit, vous ne pouvez pas charger un module nommé : show, swap, etc.
]==],
     ml_opt    = [==[L'option "%{v}" est inconnue.
  Essayez ml --help pour les instructions d'utilisation.
]==],
     ml_2many  = "erreur ml : trop de commandes\n",
     ml_misplaced_opt      = nil,

     --------------------------------------------------------------------------
     -- LmodError messages
     --------------------------------------------------------------------------
     e_Args_Not_Strings  = [==[Erreur de syntaxe dans le fichier : %{fn}
 avec la commande : %{cmdName}. Un ou plusieurs arguments ne sont pas des chaînes de caractères.
]==],
     e_Avail_No_MPATH    = "La commande 'module avail' n'est pas possible. MODULEPATH n'est pas défini ou n'est pas défini avec des chemins valides.\n",
     e_BrokenCacheFn     = nil,
     e_BrokenQ           = nil,
     e_Conflict          = "Impossible de charger le module \"%{name}\" car le(s) module(s) suivant(s) est/sont chargé(s) :\n   %{module_list}\n",
     e_Execute_Msg       = [==[Erreur de syntaxe dans le fichier : %{fn}
avec la commande : "execute".
La syntaxe est :
    execute{cmd="command string",modeA={"load",...}}
]==],
     e_Failed_2_Find     = "Impossible de trouver : \"%{name}\"\n",
     e_Failed_2_Inherit  = "Héritage impossible : %{name}\n",
     e_Failed_Hashsum    = "Impossible de calculer la somme de contrôle\n",
     e_Failed_Load       = [==[Le ou les module(s) suivants sont inconnus: %{module_list}

Veuillez vérifier l'orthographe ou le numéro de version. Vous pouvez aussi essayer "module spider ..."
Il est aussi possible que votre cache soit désuète. Essayez :
  $   module --ignore-cache load %{module_list} 
]==],
     e_Failed_Load_2     = [==[Ce ou ces module(s) existent, mais ne peuvent pas être chargés tel que demandé: %{kA}
   Utilisez: "module spider %{kB}" pour voir la façon de les charger.
]==],
     e_Family_Conflict   = [==[Vous ne pouvez avoir qu'un module %{name} chargé à la fois.
%{oldName} est déjà chargé.
Pour corriger le problème, vous pouvez utiliser la commande suivante :

  $  module swap %{oldName} %{fullName}

Merci de bien vouloir soumettre un ticket si vous désirez plus d'assistance.

]==],
     e_Illegal_Load      = nil,
     e_LocationT_Srch    = "Erreur dans la fonction 'LocationT:search()'",
     e_Missing_Value     = "%{func}(\"%{name}\") n'est pas valide, une valeur est requise",
     e_MT_corrupt        = [==[La table de modules stockée dans l'environnement est corrompue.
Veuillez exécuter la commande \" clearMT\" et charger vos modules de nouveau.
]==],
     e_No_AutoSwap       = [==[Votre site empêche l'échange automatique de modules de même nom. Vous devez explicitement décharger la version courante de "%{oldFullName}" avant de pouvoir charger la nouvelle. Vous pouvez utiliser la commande 'swap' pour cela :

   $ module swap %{oldFullName} %{newFullName}

Sinon, vous pouvez définir la variable d'environnement LMOD_DISABLE_SAME_NAME_AUTOSWAP  à "no" pour réactiver la fonction d'échange automatique des modules de même nom.
]==],
     e_No_Hashsum        = "Impossible de trouver le programme de somme de contrôle (sha1sum, shasum, md5sum or md5)",
     e_No_Matching_Mods  = "Aucun module correspondant trouvé\n",
     e_No_Mod_Entry      = "%{routine}: aucune entrée de module trouvée : \"%{name}\". Cela ne devrait pas arriver !\n",
     e_No_Period_Allowed = "Les noms de collection ne peuvent pas contenir de `.'.\n  Merci de bien vouloir renommer \"%collection}\"\n",
     e_No_PropT_Entry    = "%{routine}: la table des propriétés système n'a pas de %{location} pour : \"%{name}\". \nVérifier la syntaxe et la casse du nom.\n",
     e_No_UUID           = "uuidgen n'est pas disponible, l'alternative a également échoué",
     e_No_ValidT_Entry   = "%{routine}: La table 'validT' pour %{name} ne contient pas d'entrée pour : \"%{value}\". \nVérifier la syntaxe et la casse du nom.\n",
     e_Prereq            = "Impossible de charger le module  \"%{name}\" sans le chargement du/des module(s) suivant(s) :\n   %{module_list}\n",
     e_Prereq_Any        = "Impossible de charger le module  \"%{name}\". Au moins l'un de ces modules doit être chargé :\n   %{module_list}\n",
     e_Spdr_Timeout      = "La recherche Spider a expiré\n",
     e_Swap_Failed       = "L'échange a échoué : \"%{name}\" n'est pas chargé.\n",
     e_Unable_2_Load     = "Impossible de charger le module : %{name}\n     %{fn}: %{message}\n",
     e_Unable_2_parse    = "Impossible d'analyser : \"%{path}\". Abandon.\n",
     e_Unable_2_rename   = nil,
     e_Unknown_Coll      = "Collection de modules utilisateur : \"%{collection}\" n'existe pas.\n  Essayez \"module savelist\" pour une liste de choix possibles.\n",
     e_coll_corrupt      = "La collection de modules est corrompue. Veuillez supprimer : %{fn}\n",
     e_dbT_sn_fail       = "dbT[sn] a échoué pour sn: %{sn}\n",
     e_missing_table     = "sandbox_registration: L'argument passé est : \"%{kind}\". Cela devrait être une table.",
     e_setStandardPaths  = "Clé inconnue : \"%{key}\" dans 'setStandardPaths'\n",

     --------------------------------------------------------------------------
     -- LmodMessages
     --------------------------------------------------------------------------
     m_Activate_Modules    = "\nChargement des modules :\n",
     m_Additional_Variants = "\n    Des variantes additionnelles de ce module peuvent être chargées après le chargement des modules suivants :\n",
     m_Collection_disable  = nil,
     m_Depend_Mods         = "\n    Vous devrez charger tous les modules de l'un des lignes suivantes avant de pouvoir charger le module \"%{fullName}\".\n",
     m_Description         = "    Description:\n%{descript}\n\n",
     m_Direct_Load         = "\n    Ce module peut être chargé directement : module load %{fullName}\n",
     m_Family_Swap         = "\nLmod a automatiquement remplacé \"%{oldFullName}\" par \"%{newFullName}\"\n",
     m_For_System          = ", pour le système: \"%{sname}\"",
     m_Inactive_Modules    = "\nModules inactifs:\n",
     m_IsNVV               = nil,
     m_Module_Msgs         = [==[
%{border}
Il y a des messages associés avec le(s) module(s) suivant(s) : 
%{border}
]==],
     m_No_Named_Coll       = "Aucune collection nommée.\n",
     m_No_Search_Cmd       = [==[La commande "module search" n'existe pas. Pour lister tous les modules possibles, utilisez :

  $   module spider %{s}

Pour chercher le contenu des modules pour des mots clés, exécute z

  $   module keyword %{s}
]==],
     m_Other_matches       = "\n     Autres correspondances possibles :\n        %{bb}\n",
     m_Other_possible      = [==[
     Autres candidats possibles : 
        %{b}
]==],
     m_Properties      = "    Propriétés:\n",
     m_Regex_Spider        = [==[%{border}  Pour trouver d'autres correspondances à votre recherche, exécutez : 

      $ module -r spider '.*%{name}.*'

]==],
     m_Reload_Modules      = "\nDû à un changement dans la variable MODULEPATH, les modules suivants ont été rechargés :\n",
     m_Reload_Version_Chng = "\nLes modules suivants ont été rechargés avec un changement de version :\n",
     m_Restore_Coll        = "Restauration des modules de la collection %{msg}\n",
     m_Reset_SysDflt       = "Restauration de l'environnement par défaut\n",
     m_Save_Coll           = "Collection de modules sauvegardée vers : \"%{a}\"%{msgTail}\n",
     m_Spdr_L1             = [==[%{border}  Pour de l'information détaillée à propos d'un module "%{key}" spécifique (incluant comment charger ce module), utilisez le nom complet.
  Par exemple : 

     $ module spider %{exampleV}
%{border}]==],
     m_Spider_Title        = "Liste des modules disponibles présentement :\n",
     m_Spider_Tail         = [==[%{border}
Pour en savoir davantage sur un module exécutez : 

   $ module spider Foo

où "Foo" est le nom d'un module.

S'il existe plusieurs version d'un module, vous devez spécifier la version
afin d'avoir l'information détaillée :

   $ module spider Foo/11.1

%{border}]==],
     m_Sticky_Mods      = [==[Les modules suivants n'ont pas été elevés de votre environnement :
  (Utilisez "module --force purge" pour tous les enlever):
]==],
     m_Sticky_Unstuck      = "\nLes modules suivants sont permanents (sticky) et n'ont pas pu être chargés de nouveau :\n",
     m_Versions            = "     Versions:\n",
     m_Where      = "\n  Où:\n",

     --------------------------------------------------------------------------
     -- LmodWarnings
     --------------------------------------------------------------------------
     w_Broken_Coll     = [==[Un ou plusieurs modules de la collection %{collectionName} ont changé : "%{module_list}".
Pour voir le contenu de cette collection :
  $ module describe %{collectionName}
Pour reconstruire la collection, chargez les modules souhaités, puis :
  $ module save %{collectionName}
Si vous souhaitez supprimer cette collection de modules :
  $ rm ~/.lmod.d/%{collectionName}

Pour plus d'informations, lancez 'module help' ou consultez http://lmod.readthedocs.org/
Aucun changement dans les modules chargés

]==],
     w_Broken_FullName = "Ligne module-version malformée : module-name doit être un nom complet : %{fullName} ne l'est pas\n",
     w_Empty_Coll      = "Vous n'avez aucun module de chargé car la collection \"%{collectionName}\" est vide !\n",
     w_Failed_2_Find      = [==[Lmod n'a pas pu trouver les modules suivants :  "%{quote_comma_list}" dans votre MODULEPATH
Essayez:

    $ module spider %{module_list}

pour vérifier si les modules sont disponibles avec l'un des compilateurs ou implémentation MPI installés.
]==],
     w_MissingModules  = nil,
     w_MPATH_Coll      = "La variable MODULEPATH du système a changé : merci de bien vouloir reconstruire les collections que vous avez sauvegardées.\n",
     w_Mods_Not_Loaded = "Les modules suivants n'ont pas été chargés : %{module_list}\n\n",
     w_No_Coll         = "Aucune collection \"%{collection}\" n'a été trouvée.",
     w_No_dot_Coll     = "Les noms de collection ne peuvent pas contenir de '.'. Merci de bien vouloir choisir un autre nom pour : %{name}",
     w_Save_Empty_Coll = [==[Vous tentez de sauvegarder une collection de modules vide dans "%{name}". Si c'est ce que vous souhaitez, utilisez :
  $  module --force save %{name}
]==],
     w_SYS_DFLT_EMPTY    = [==[
L'environnement par défaut ne contient aucun module
  (la variable d'environnement : LMOD_SYSTEM_DEFAULT_MODULES est vide)
  Aucun changement dans les modules chargés.

]==],
     w_System_Reserved = "Le nom 'system' pour une collection est réservé. Merci de bien vouloir choisir un autre nom.\n",

     w_Undef_MPATH     = "MODULEPATH n'est pas défini\n",
     w_Unknown_Hook      = "Crochet (hook) inconnu : %{name}\n",
     
     --------------------------------------------------------------------------
     -- Usage Message
     --------------------------------------------------------------------------
     usage_cmdline = "module [options] sub-command [args ...]",
     help_title    = "Sous-commandes d'aide :\n" ..
                     "-----------------------",
     help1         = "affiche ce message",
     help2         = "affiche le message d'aide du module correspondant",

     load_title    =  "Sous-commandes de chargement/déchargement :\n" ..
                      "-------------------------------------------",
     load1         = "charge un ou des modules",
     load2         = "Ajoute un ou des modules, n'affiche pas d'erreur si le module n'est pas trouvé",
     load3         = "Enlève un ou des modules, n'affiche pas d'erreur si le module n'est pas trouvé",
     load4         = "enlève m1 et charge m2",
     load5         = "enlève tous les modules",
     load6         = "rafraîchi les alias de la liste courante de modules.",
     load7         = "rafraîchi tous les modules présentement chargés.",

     list_title    = "Sous-commandes pour lister / chercher :\n" ..
                     "---------------------------------------",
     list1         = "Liste les modules chargés",
     list2         = "Liste les modules chargés qui correspondent à la recherche",
     list3         = "Liste les modules disponibles",
     list4         = "Liste les modules disponibles qui contiennent \"string\".",
     list5         = "Liste tous les modules existants",
     list6         = "Liste toutes les versions d'un module",
     list7         = "Liste tous les modules qui contiennent \"string\".",          
     list8         = "Information détaillée à propos de cette version du module.",
     list9         = "Affiche l'information \"whatis\" à propos de ce module",
     list10        = "Cherche tous les noms et descriptions (\"whatis\") qui contiennent \"string\".",

     srch_title    = "Chercher avec Lmod:\n" ..
                     "-------------------",
     srch0         = "  Toutes les sous-commandes de recherche (spider, list, avail, keyword) supportent les expressions régulières :",
     srch1         = "Trouve tous les modules qui débutent par `p' or `P'",
     srch2         = "Trouve tous les modules qui ont \"mpi\" dans leur nom.",
     srch3         = "Trouve tous les modules dont le nom se termine par \"mpi\".",

     collctn_title = "Gérer une collection de modules :\n"..
                     "---------------------------------",
     collctn1      = "Sauvegarde la liste actuelle de modules vers une collection \"default\" définie par l'usage.",
     collctn2      = "Sauvegarde la liste actuelle de modules vers une collection nommée \"name\".",
     collctn3      = "Identique à \"restore system\"",
     collctn4      = "Restaure les modules de la collection par défaut de l'usager si elle existe, ou du système sinon.",
     collctn5      = "Restaure les modules de la collection nommée \"name\".",
     collctn6      = "Restaure les modules à l'état par défaut du système.",                                 
     collctn7      = "Affiche la liste des collections sauvegardées.",
     collctn8      = "Décrit le contenu d'une collection.",
     collctn9      = nil,

     depr_title    = "Sous-commandes désuètes :\n" ..
                     "-------------------------",
     depr1         = "charge la collection nommée \"name\" de l'usager, ou la collection par défaut si aucun nom n'est fourni.",
     depr2         = "===> Utilisez plutôt \"restore\"  <====",
     depr3         = "sauvegarde liste actuelle de modules dans la collection \"name\" si un nom est donné. Si aucun nom n'est donné, sauvegarde la liste en tant que liste par défaut pour l'usager.",
     depr4         = "===> Utilisez plutôt \"save\". <====",

     misc_title    = "Sous-commandes diverses:\n" ..
                     "---------------------------",
     misc1         = "affiche les commandes contenues dans le fichier de module.",
     misc2         = "Ajoute un chemin au début (prepend) ou à la fin (append) de la variable d'environnement MODULEPATH.",
     misc3         = "Enlève le chemin de la variable d'environnement MODULEPATH.",
     misc4         = "Affiche la liste des modules actifs sous la forme d'une table lua.",


     env_title     = "Variables d'environnement importantes :\n" ..
                     "---------------------------------------",
     env1          = "Si la valeur est \"YES\" alors Lmod affichera les propriétés et avertissements en couleur.",
     web_sites     = "Sites web de Lmod",
     rpt_bug       = "  Pour rapporter un bogue, veuillez lire ",
     
     --------------------------------------------------------------------------
     -- module help strings
     --------------------------------------------------------------------------
     
     StickyM   = "Le module est permanent - nécessite --force pour l'enlever ou purger les modules",
     LoadedM   = "Le module est chargé",
     ExplM     = "Expérimental",
     TstM      = "Test",
     ObsM      = "Obsolète",

     help_hlp  = "Ce message d'aide",
     style_hlp = "Style contrôlé par le site pour \"avail\" : %{styleA} (défaut: %{default})",
     rt_hlp    = "Test de régression de Lmod",
     dbg_hlp   = "Trace du programme écrite vers stderr",
     pin_hlp   = "Lors d'une restauration, utiliser la version spécifiée, et ignorer la version par défaut",
     avail_hlp = "Affiche seulement les modules par défaut lorsque la commande avail est utilisée",
     quiet_hlp = "N'affiche pas les avertissements",
     exprt_hlp = "Mode expert",
     terse_hlp = "Affichage dans un format lisible par l'ordinateur pour les commandes: list, avail, spider, savelist",
     initL_hlp = "Chargement de Lmod pour la première fois dans une session d'usager",
     latest_H  = "Charge la version la plus récente (ignore la version par défaut)",
     cache_hlp = "Considère la cache comme étant désuète",
     novice_H  = "Désactive le mode expert",
     raw_hlp   = "Lorsqu'utilisé avec la sous-commande show, affiche le contenu du fichier de module de façon non formattée",
     width_hlp = "Change la largeur de l'affichage",
     v_hlp     = "Affiche la version",
     rexp_hlp  = "Fait une recherche par expression régulière",
     gitV_hlp  = "Affiche la version git dans un format lisible par l'ordinateur",
     dumpV_hlp = "Affiche la version dans un format lisible par l'ordinateur",
     chkSyn_H  = "Vérifie la syntaxe, ne charge pas le module",
     config_H  = "Affiche la configuration Lmod",
     jcnfig_H  = "Affiche la configuration Lmod dans un format json",
     MT_hlp    = "Affiche la table de l'état des modules",
     timer_hlp = "Affiche le temps d'exécution",
     force_hlp = "Force la désactivation d'un module permanent, ou force la sauvegarde d'une collection vide",
     redirect_H= "Affiche la sortie de list, avail, spider vers stdout (plutôt que stderr)",
     nrdirect_H= "Affiche la sortie de list, avail, spider vers stderr",
     hidden_H  = "Avail et spider afficheront les modules cachés",
     spdrT_H   = "un délai maximal pour spider",
     trace_T   = nil,


     Where     = "\n  Où :\n",
     Inactive  = "\nModules Inactifs",

     avail     = [==[Utilisez "module spider" pour trouver tous les modules possibles.
Utilisez "module keyword key1 key2 ..." pour chercher tous les modules possibles qui correspondent à l'une des clés (key1, key2).
]==],
     list      = " ",
     spider    = " ",
     aliasMsg  = "Des alias existent: foo/1.2.3 (1.2) signifie que \"module load foo/1.2\" chargera le module foo/1.2.3",
     noModules = "Aucun module trouvé!",
     noneFound = "  Aucun trouvé",


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

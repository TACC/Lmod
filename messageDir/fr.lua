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
   fr = {
     errTitle  = "Lmod a détecté l'erreur suivante : ",
     warnTitle = "Lmod Warning: ",
     --------------------------------------------------------------------------
     -- LmodError messages
     --------------------------------------------------------------------------
     e101 = "Impossible de trouver le programme de somme de contrôle (sha1sum, shasum, md5sum or md5)",
     e102 = "Impossible d'analyser : \"%{path}\". Abandon.\n",
     e103 = "Erreur dans la fonction 'LocationT:search()'",
     e104 = "%{routine}: aucune entrée de module trouvée : \"%{name}\". Cela ne devrait pas arriver !\n",
     e105 = "%{routine}: la table des propriétés système n'a pas de %{location} pour : \"%{name}\". \nVérifier la syntaxe et la casse du nom.\n",
     e106 = "%{routine}: La table 'validT' pour %{name} ne contient pas d'entrée pour : \"%{value}\". \nVérifier la syntaxe et la casse du nom.\n",
     e107 = "Impossible de trouver : \"%{name}\"\n",
     e108 = "Héritage impossible : %{name}\n",
     e109 = [==[Votre site empêche l'échange automatique de modules de même nom. Vous devez explicitement décharger la version courante de "%{oldFullName}" avant de pouvoir charger la nouvelle. Vous pouvez utiliser la commande 'swap' pour cela :

   $ module swap %{oldFullName} %{newFullName}

Sinon, vous pouvez définir la variable d'environnement LMOD_DISABLE_SAME_NAME_AUTOSWAP  à "no" pour réactiver la fonction d'échange automatique des modules de même nom.
]==],
     e110 = "La commande 'module avail' n'est pas possible. MODULEPATH n'est pas défini ou n'est pas défini avec des chemins valides.\n",
     e111 = "%{func}(\"%{name}\") n'est pas valide, une valeur est requise",
     e112 = "Impossible de charger le module \"%{name}\" car le(s) module(s) suivant(s) est/sont chargé(s) :\n   %{module_list}\n",
     e113 = "Impossible de charger le module  \"%{name}\" sans le chargement du/des module(s) suivant(s) :\n   %{module_list}\n",
     e114 = "Impossible de charger le module  \"%{name}\". Au moins l'un de ces modules doit être chargé :\n   %{module_list}\n",
     e115 = [==[Vous ne pouvez avoir qu'un module %{name} chargé à la fois.
%{oldName} est déjà chargé.
Pour corriger le problème, vous pouvez utiliser la commande suivante :

  $  module swap %{oldName} %{fullName}

Merci de bien vouloir soumettre un ticket si vous désirez plus d'assistance.

]==],
     e116 = "Clé inconnue : \"%{key}\" dans 'setStandardPaths'\n",
     e117 = "Aucun module correspondant trouvé\n",
     e118 = "Collection de modules utilisateur : \"%{collection}\" n'existe pas.\n  Essayez \"module savelist\" pour une liste de choix possibles.\n",
     e119 = "Les noms de collection ne peuvent pas contenir de `.'.\n  Merci de bien vouloir renommer \"%collection}\"\n",
     e120 = "L'échange a échoué : \"%{name}\" n'est pas chargé.\n",
     e121 = "Impossible de charger le module : %{name}\n     %{fn}: %{message}\n",

     e122 = "sandbox_registration: L'argument passé est : \"%{kind}\". Cela devrait être une table.",
     e123 = "uuidgen n'est pas disponible, l'alternative a également échoué",
     e124 = "La recherche Spider a expiré\n",
     e125 = "dbT[sn] a échoué pour sn: %{sn}\n",
     e126 = "Impossible de calculer la somme de contrôle\n",
     e127 = [==[Le ou les module(s) suivants sont inconnus: %{module_list}

Veuillez vérifier l'orthographe ou le numéro de version. Vous pouvez aussi essayer "module spider ..."
Il est aussi possible que votre cache soit désuète. Essayez :
  $   module --ignore-cache load %{module_list} 
]==],
     e128 = [==[Ce ou ces module(s) existent, mais ne peuvent pas être chargés tel que demandé: %{kA}
   Utilisez: "module spider %{kB}" pour voir la façon de les charger.
]==],

     e129 = [==[Erreur de syntaxe dans le fichier : %{fn}
 avec la commande : %{cmdName}. Un ou plusieurs arguments ne sont pas des chaînes de caractères.
]==],
     e130 = [==[Erreur de syntaxe dans le fichier : %{fn}
avec la commande : "execute".
La syntaxe est :
    execute{cmd="command string",modeA={"load",...}}
]==],
     
     --------------------------------------------------------------------------
     -- LmodMessages
     --------------------------------------------------------------------------
     m401 = "\nLmod a automatiquement remplacé \"%{oldFullName}\" par \"%{newFullName}\"\n",
     
     --------------------------------------------------------------------------
     -- LmodWarnings
          --------------------------------------------------------------------------
     w501 = [==[Un ou plusieurs modules de la collection %{collectionName} ont changé : "%{module_list}".
Pour voir le contenu de cette collection :
  $ module describe %{collectionName}
Pour reconstruire la collection, chargez les modules souhaités, puis :
  $ module save %{collectionName}
Si vous souhaitez supprimer cette collection de modules :
  $ rm ~/.lmod.d/%{collectionName}

Pour plus d'informations, lancez 'module help' ou consultez http://lmod.readthedocs.org/
Aucun changement dans les modules chargés

]==],
     w502 = "Ligne module-version malformée : module-name doit être un nom complet : %{fullName} ne l'est pas\n",
     w503 = "La variable MODULEPATH du système a changé : merci de bien vouloir reconstruire les collections que vous avez sauvegardées.\n",
     w504 = "Vous n'avez aucun module de chargé car la collection \"%{collectionName}\" est vide !\n",
     w505 = "Les modules suivants n'ont pas été chargés : %{module_list}\n\n",
     w506 = "Aucune collection \"%{collection}\" n'a été trouvée.",
     w507 = "MODULEPATH n'est pas défini\n",
     w508 = "Les noms de collection ne peuvent pas contenir de '.'. Merci de bien vouloir choisir un autre nom pour : %{name}",
     w509 = "Le nom 'system' pour une collection est réservé. Merci de bien vouloir choisir un autre nom.\n",
     w510 = [==[Vous tentez de sauvegarder une collection de modules vide dans "%{name}". Si c'est ce que vous souhaitez, utilisez :
  $  module --force save %{name}
]==],
   }
}

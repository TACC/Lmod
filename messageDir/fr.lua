return {
   fr = {
     errTitle = "Lmod a détecté l'erreur suivante: ",
     --------------------------------------------------------------------------
     -- LmodError messages
     --------------------------------------------------------------------------
     e101 = "Impossible de trouver le programme d'HashSum(sha1sum, shasum, md5sum or md5)",
     e102 = "Impossible d'analyser: \"%{path}\". Abandon\n",
     e107 = "Impossible de trouver: \"%{name}\"\n",
     e110 = "La commande 'module avail' n'est pas possible. MODULEPATH n'est pas défini ou n'est pas défini avec des chemins valides.\n",
     e112 = "Impossible de charger le module \"%{name}\" car le/les module(s) suivant(s) est/sont charge(s):\n   %{module_list}\n",
     e113 = "Impossible de charger le module  \"%{name}\" sans le chargement du/des module(s) suivant(s):\n   %{module_list}\n",
     e114 = "Impossible de charger le module  \"%{name}\". Au moins l'un de ces modules doit etre charges:\n   %{module_list}\n",
     e115 = [==[Vous ne pouvez avoir qu'un module %{name} charge a la fois.
Vous avez deja %{oldName} charge.
Pour corriger le probleme, entrer svp la commande suivante:

  $  module swap %{oldName} %{fullName}

Soumettez svp un ticket si vous desirez une assistance supplementaire.

]==],
     e116 = "Cle inconnue: \"%{key}\" in setStandardPaths\n",
     e117 = "Pas de module correspondant trouve\n",
     e121 = "Impossible de charger le module: %{name}\n     %{fn}: %{message}\n",

     --------------------------------------------------------------------------
     -- LmodMessages
     --------------------------------------------------------------------------
     m401 = "\nLmod est en train de remplacer automatiquement \"%{oldFullName}\" par \"%{newFullName}\"\n",
     
     --------------------------------------------------------------------------
     -- LmodWarnings
     w506 = "Pas de collection correspondant au nom \"%{collection}\" trouve.",
     w507 = "MODULEPATH est indefini\n",
     w509 = "Le nom 'system' pour une collection est reserve. Veuillez choisir un autre nom.\n",
   }
}

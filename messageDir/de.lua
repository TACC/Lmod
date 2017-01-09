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
   de = {
     errTitle = "Lmod hat den folgenden Fehler erkannt: ",
     warnTitle = "Lmod Warning: ",

     --------------------------------------------------------------------------
     -- LmodError messages
     --------------------------------------------------------------------------
     e101 = "Kein Programm zum Bestimmen von Hashwerten verfügbar (sha1sum, shasum, md5sum oder md5).",
     e102 = "Nicht einlesbar: \"%{path}\". Abbruch!\n",
     e103 = "Fehler in LocationT:search().",
     e104 = "%{routine}: Kein Modul für \"%{name}\" gefunden. Das sollte nicht passieren!\n",
     e105 = [==[%{routine}: Systemeinstellungs-Tabelle enthält keine %{location} für: "%{name}".
Überprüfen Sie die Schreibweise des Namens.
]==],
     e106 = [==[%{routine}: Die validT-Tabelle für %{name} hat keinen Eintrag für: "%{value}".
Überprüfen Sie die Schreibweise des Namens.
]==],
     e107 = "Nicht auffindbar: \"%{name}\".\n",
     e108 = "Fehler bei der Vererbung: %{name}.\n",
     e109 = [==[Die Einstellungen verhindern den automatischen Austausch von Modulen mit gleichen Namen. Die geladene Version von "%{oldFullName}" muss entladen werden, bevor eine andere Version geladen werden kann. Verwenden Sie dafür swap wie folgt:

  $ module swap %{oldFullName} %{newFullName}

Alternativ können Sie die Umgebungsvariable LMOD_DISABLE_SAME_NAME_AUTOSWAP auf "no" setzen, um den automatischen Austausch von Modulen zu aktivieren.
]==],
     e110 = "Das Kommando 'module avail' kann nicht ausgeführt werden. Die Variable MODULEPATH ist entweder nicht gesetzt oder enthält einen ungültigen Wert.",
     e111 = "%{func}(\"%{name}\") ist ungültig, es wird ein Wert benötigt.",
     e112 = [==[Das Modul "%{name}" kann nicht geladen werden, weil diese Module geladen sind:
  %{module_list}
]==],
     e113 = [==[Das Modul "%{name}" kann ohne diese Module nicht geladen werden:
  %{module_list}
]==],
     e114 = [==[Das Modul "%{name}" kann nicht geladen werden. Mindestens eines dieser Module muss geladen sein:
  %{module_list}
]==],
     e115 = [==[Nur ein Modul von %{name} kann gleichzeitig geladen sein.
Es ist bereits %{oldName} geladen.
Verwende folgendes Kommando, um das Modul zu laden:

  $ module swap %{oldName} %{fullName}

Falls Sie weitere Unterstützung brauchen, erstellen Sie ein Support-Ticket.
]==],
     e116 = "Unbekannter Schlüssel: \"%{key}\" in setStandardPaths.\n",
     e117 = "Keine passenden Module gefunden.\n",
     e118 = [==[Benutzer-Modulsammlung: "%{collection}" existiert nicht.
  "module savelist" zeigt mögliche Werte.
]==],
     e119 = [==[Der Name einer Modulsammlung darf kein `.' enthalten.
  Bitte geben Sie der Sammlung "%{collection}" einen neuen Namen.
]==],
     e120 = "Swap fehlgeschlagen: \"%{name}\" ist nicht geladen.\n",
     e121 = [==[Modul konnte nicht geladen werden: %{name}
     %{fn}: %{message}
]==],
     e122 = "sandbox_registration: Das übergebene Argument ist vom Typ: \"%{kind}\". Es sollte eine Liste sein.",
     e123 = "uuidgen ist nicht verfügbar, Alternative ist ebenfalls fehlgeschlagen.",
     e124 = "Zeitbegrenzung für Spider-Suche ist abgelaufen.\n",
     e125 = "dbT[sn] schlug fehl für sn: %{sn}.\n",
     e126 = "Hashwert konnte nicht berechnet werden.\n",

     --------------------------------------------------------------------------
     -- LmodMessages
     --------------------------------------------------------------------------
     m401 = "\nLmod hat \"%{oldFullName}\" automatisch durch \"%{newFullName}\" ersetzt.\n",

     --------------------------------------------------------------------------
     -- LmodWarnings
     --------------------------------------------------------------------------
     w501 = [==[Ein oder mehrere Module in ihrer Sammlung %{collectionName} wurden geändert: "%{module_list}".
Um die Inhalte der Sammlung anzuzeigen, verwenden Sie:
  $ module describe %{collectionName}
Um die Sammlung neu anzulegen, laden Sie zuerst die gewünschten Module und führen Sie danach folgendes aus:
  $ module save %{collectionName}
Falls Sie die Modulsammlung löschen möchten, verwenden Sie:
  $ rm ~/.lmod.d/%{collectionName}

Weitere Informationen finden Sie mit 'module help' oder unter http://lmod.readthedocs.org/.
Die geladenen Module wurden nicht verändert.

]==],
     w502 = "Fehler in der Zeile module-version: module-name muss vollqualifiziert sein: %{fullName} ist dies nicht.\n",
     w503 = "MODULEPATH des Systems hat sich geändert: Bitte legen Sie ihre gespeicherten Sammlungen neu an.\n",
     w504 = "Sie haben keine Module geladen, weil die Sammlung \"%{collectionName}\" leer ist!\n",
     w505 = "Die folgenden Module wurden nicht geladen: %{module_list}.\n\n",
     w506 = "Keine Sammlung mit dem Namen \"%{collection}\" gefunden.",
     w507 = "MODULEPATH ist nicht definiert.\n",
     w508 = "Der Name einer Sammlung darf kein `.' enthalten. Bitte vergeben Sie einen anderen Namen für: %{name}.",
     w509 = "Die Bezeichnung 'system' für Sammlungen ist reserviert. Bitte vergeben Sie einen anderen Namen.\n",
     w510 = [==[Sie versuchen in "%{name}" eine leere Modulsammlung zu speichern. Falls Sie dies wollen, verwenden Sie:
  $ module --force save %{name}
]==],
   }
}

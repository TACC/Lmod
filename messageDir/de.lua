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
   de = {
     --------------------------------------------------------------------------
     -- Error/Warning Titles
     --------------------------------------------------------------------------
     errTitle            = "Lmod hat den folgenden Fehler erkannt: ",
     warnTitle           = "Lmod Warnung: ",

     --------------------------------------------------------------------------
     -- ml messages
     --------------------------------------------------------------------------

     ml_help               = [==[
   ml: Ein nützliches Frontend für den module-Befehl:
   Einfache Verwendung:
   -------------
     $ ml
                              bedeutet: "module list"
     $ ml foo bar
                              bedeutet: "module load foo bar"
     $ ml -foo -bar baz goo
                              bedeutet: "module unload foo bar;
                                        module load baz goo;"

   Befehlsverwendung:
   --------------
   Jeder "module"-Befehl kann nach "ml" verwendet werden:
   Wenn "name" avail, save, restore, show, swap, ... ist
       $ ml name  arg1 arg2 ...
   dann bedeutet dies das Gleiche wie:
       $ module name arg1 arg2 ...
   Module mit Namen wie show, swap ... können nicht geladen werden.
]==],
     ml_opt                = [==[Option: "%{v}" ist unbekannt.
  Geben Sie "ml --help" für Informationen zur Verwendung ein.
]==],
     ml_2many              = "ml Fehler: zu viele Befehle\n",
     ml_misplaced_opt      = nil,

     --------------------------------------------------------------------------
     -- LmodError messages
     --------------------------------------------------------------------------
     e_Args_Not_Strings    = [==[Syntax-Fehler in dieser Datei: %{fn}
bei dem Befehl "%{cmdName}", ein oder mehrere Argumente sind keine Strings.
]==],
     e_Avail_No_MPATH      = "Der Befehl \"module avail\" kann nicht ausgeführt werden. Die Variable MODULEPATH ist entweder nicht gesetzt oder enthält einen ungültigen Wert.",
     e_BrokenCacheFn       = nil,
     e_BrokenQ             = nil,
     e_Conflict            = [==[Das Modul "%{name}" kann nicht geladen werden, weil diese Module geladen sind:
  %{module_list}
]==],
     e_Execute_Msg         = [==[Syntax-Fehler in dieser Datei: %{fn}
bei dem Befehl: "execute".
Die korrekte Syntax ist:
    execute{cmd="command string",modeA={"load",...}}
]==],
     e_Failed_2_Find       = "Nicht auffindbar: \"%{name}\".\n",
     e_Failed_2_Inherit    = "Fehler bei der Vererbung: \"%{name}\".\n",
     e_Failed_Hashsum      = "Hashwert konnte nicht berechnet werden.\n",
     e_Failed_Load         = [==[Die folgenden Module konnten nicht gefunden werden: %{module_list}
Bitte überprüfen Sie die Schreibweise oder Versionsnummer. Sie können auch "module spider ..." versuchen.
Es ist auch möglich, dass Ihr Cache veraltet ist. Versuchen Sie:
  $ module --ignore-cache load %{module_list}
]==],
     e_Failed_Load_2       = [==[Diese Module existieren, aber können nicht wie gewünscht geladen werden: %{kA}
   Versuchen Sie: "module spider %{kB}" um anzuzeigen, wie die Module geladen werden.
]==],
     e_Family_Conflict     = [==[Nur ein Modul von "%{name}" kann gleichzeitig geladen sein.
Es ist bereits "%{oldName}" geladen.
Verwenden Sie folgendes Kommando, um das Modul zu laden:

  $ module swap %{oldName} %{fullName}

Falls Sie weitere Unterstützung brauchen, erstellen Sie ein Support-Ticket.
]==],
     e_Illegal_Load        = nil,
     e_LocationT_Srch      = "Fehler in \"LocationT:search()\".",
     e_Missing_Value       = "%{func}(\"%{name}\") ist ungültig. Es wird ein Wert benötigt.",
     e_MT_corrupt          = [==[Die gespeicherte Modul-Liste ist beschädigt.
Bitte führen Sie den Befehl \"clearMT\" aus und laden Sie ihre Module erneut.
]==],
     e_No_AutoSwap         = [==[Die Einstellungen verhindern den automatischen Austausch von Modulen mit gleichen Namen. Die geladene Version von "%{oldFullName}" muss entladen werden, bevor eine andere Version geladen werden kann. Verwenden Sie dafür swap wie folgt:

  $ module swap %{oldFullName} %{newFullName}

Alternativ können Sie die Umgebungsvariable LMOD_DISABLE_SAME_NAME_AUTOSWAP auf "no" setzen, um den automatischen Austausch von Modulen zu aktivieren.
]==],
     e_No_Hashsum          = "Kein Programm zum Bestimmen von Hashwerten verfügbar (sha1sum, shasum, md5sum oder md5).",
     e_No_Matching_Mods    = "Keine passenden Module gefunden.\n",
     e_No_Mod_Entry        = "%{routine}: Kein Modul für \"%{name}\" gefunden. Das sollte nicht passieren!\n",
     e_No_Period_Allowed = [==[Der Name einer Modulsammlung darf keinen Punkt ('.') enthalten.
  Bitte geben Sie der Sammlung "%{collection}" einen neuen Namen.
]==],
     e_No_PropT_Entry      = [==[%{routine}: Systemeinstellungs-Tabelle enthält keine "%{location}" für: "%{name}".
Überprüfen Sie die Schreibweise des Namens.
]==],
     e_No_UUID             = "uuidgen ist nicht verfügbar, Alternative ist ebenfalls fehlgeschlagen.",
     e_No_ValidT_Entry     = [==[%{routine}: Die validT-Tabelle für "%{name}" hat keinen Eintrag für: "%{value}".
Überprüfen Sie die Schreibweise des Namens.
]==],
     e_Prereq              = [==[Das Modul "%{name}" kann ohne diese Module nicht geladen werden:
  %{module_list}
]==],
     e_Prereq_Any          = [==[Das Modul "%{name}" kann nicht geladen werden. Mindestens eines dieser Module muss geladen sein:
  %{module_list}
]==],
     e_Spdr_Timeout        = "Zeitbegrenzung für Spider-Suche ist abgelaufen.\n",
     e_Swap_Failed         = "Swap fehlgeschlagen: \"%{name}\" ist nicht geladen.\n",
     e_Unable_2_Load       = [==[Modul konnte nicht geladen werden: "%{name}"
     %{fn}: %{message}
]==], --
     e_Unable_2_parse      = "Nicht einlesbar: \"%{path}\". Abbruch!\n",
     e_Unable_2_rename     = nil,
     e_Unknown_Coll        = [==[Benutzer-Modulsammlung: "%{collection}" existiert nicht.
  "module savelist" zeigt mögliche Werte.
]==],
     e_coll_corrupt        = "Die Modulsammlungsdatei ist beschädigt. Bitte entfernen Sie: \"%{fn}\".\n",
     e_dbT_sn_fail         = "dbT[sn] schlug fehl für sn: %{sn}.\n",
     e_missing_table       = "sandbox_registration: Das übergebene Argument ist vom Typ: \"%{kind}\". Es sollte eine Liste sein.",
     e_setStandardPaths    = "Unbekannter Schlüssel: \"%{key}\" in setStandardPaths.\n",

     --------------------------------------------------------------------------
     -- LmodMessages
     --------------------------------------------------------------------------
     m_Activate_Modules    = "\nAktiviere Module:\n",
     m_Additional_Variants = "\n    Zusätzliche Varianten des Moduls können geladen werden, nachdem die folgenden Module geladen wurden:\n",
     m_Collection_disable  = nil,
     m_Depend_Mods         = "\n    Sie müssen alle Module in einer der nachfolgenden Zeilen laden bevor Sie das Modul \"%{fullName}\" laden können.\n",
     m_Description         = "    Beschreibung:\n%{descript}\n\n",
     m_Direct_Load         = "\n    Dieses Modul kann direkt geladen werden: \"module load %{fullName}\".\n",
     m_Family_Swap         = "\nLmod hat \"%{oldFullName}\" automatisch durch \"%{newFullName}\" ersetzt.\n",
     m_For_System          = ", für das System: \"%{sname}\"",
     m_Inactive_Modules    = "\nInaktive Module:\n",
     m_IsNVV               = nil,
     m_Module_Msgs         = [==[
%{border}
Es gibt Meldungen, die zu den folgenden Modulen gehören:
%{border}
]==],
     m_No_Named_Coll       = "Keine benannten Sammlungen verfügbar.\n",
     m_No_Search_Cmd       = [==[Der Befehl "module search" existiert nicht. Um alle verfügbaren Module anzuzeigen, verwenden Sie:
  $ module spider %{s}
Um die Inhalte von Modulen nach Schlüsselwörtern zu durchsuchen, verwenden Sie:
  $ module keyword %{s}
]==],
     m_Other_matches       = [==[
     Andere Übereinstimmungen mit Modulen:
        %{bb}
]==],
     m_Other_possible      = [==[
     Andere Übereinstimmungen mit Modulen:
        %{b}
]==],
     m_Properties          = "    Eigenschaften:\n",
     m_Regex_Spider        = [==[%{border}  Um weitere Übereinstimmungen mit Modulen zu finden, verwenden Sie:
  $ module -r spider '.*%{name}.*'
]==],
     m_Reload_Modules      = "\nWegen Änderungen an MODULEPATH wurden folgende Module erneut geladen:\n",
     m_Reload_Version_Chng = "\nDie folgenden Module wurden in einer anderen Version erneut geladen:\n",
     m_Restore_Coll        = "Module werden aus \"%{msg}\" wiederhergestellt.\n",
     m_Reset_SysDflt       = "Die Module werden auf den System-Standard zurückgesetzt.\n",
     m_Save_Coll           = "Die aktuelle Modulsammlung wurde gespeichert nach: \"%{a}%{msgTail}\".\n",
     m_Spdr_L1             = [==[%{border}  Um detaillierte Informationen über ein bestimmtes "%{key}"-Modul zu erhalten (auch wie das Modul zu laden ist), verwenden sie den vollständigen Namen des Moduls.
  Zum Beispiel:
    $ module spider %{exampleV}
%{border}]==],
     m_Spider_Title        = "Dies ist eine Liste aller verfügbaren Module:\n",
     m_Spider_Tail         = [==[%{border}
Um mehr über ein Modul zu erfahren, verwenden Sie:
  $ module spider Foo
wobei "Foo" der Name eines Moduls ist.
Um detaillierte Informationen über ein bestimmtes Modul zu erhalten,
müssen Sie eine Version angeben, falls es mehr als eine Version gibt:
  $ module spider Foo/11.1
%{border}]==],
     m_Sticky_Mods         = [==[Die folgenden Module wurde nicht entladen:
  (Benutzen Sie "module --force purge" um alle Module zu entladen):
]==],
     m_Sticky_Unstuck      = "\nDie folgenden angehefteten Module konnten nicht erneut geladen werden:\n",
     m_Versions            = "     Versionen:\n",
     m_Where               = "\n  Wo:\n",

     --------------------------------------------------------------------------
     -- LmodWarnings
     --------------------------------------------------------------------------
     w_Broken_Coll         = [==[Ein oder mehrere Module in ihrer Sammlung "%{collectionName}" wurden geändert: %{module_list}.
Um die Inhalte der Sammlung anzuzeigen, verwenden Sie:
  $ module describe %{collectionName}
Um die Sammlung neu anzulegen, laden Sie zuerst die gewünschten Module und führen Sie danach folgendes aus:
  $ module save %{collectionName}
Falls Sie die Modulsammlung löschen möchten, verwenden Sie:
  $ rm ~/.lmod.d/%{collectionName}

Weitere Informationen finden Sie mit "module help" oder unter http://lmod.readthedocs.org/.
Die geladenen Module wurden nicht verändert.

]==],
     w_Broken_FullName     = "Fehler in der Zeile \"module-version\": \"module-name\" muss vollqualifiziert sein: \"%{fullName}\" ist dies nicht.\n",
     w_Empty_Coll          = "Sie haben keine Module geladen, weil die Sammlung \"%{collectionName}\" leer ist!\n",
     w_Failed_2_Find       = [==[Die folgenden Module konnten nicht in Ihrem MODULEPATH gefunden werden:  "%{quote_comma_list}".
Versuchen Sie:
  $ module spider %{module_list}
um in allen Compilern und MPI-Implementierungen zu suchen.
]==],
     w_MissingModules      = nil,
     w_MPATH_Coll          = "MODULEPATH des Systems hat sich geändert: Bitte legen Sie ihre gespeicherten Sammlungen neu an.\n",
     w_Mods_Not_Loaded     = "Die folgenden Module wurden nicht geladen: %{module_list}.\n\n",
     w_No_Coll             = "Keine Sammlung mit dem Namen \"%{collection}\" gefunden.",
     w_No_dot_Coll         = "Der Name einer Sammlung darf keinen Punkt ('.') enthalten. Bitte vergeben Sie einen anderen Namen für \"%{name}\".",
     w_Save_Empty_Coll     = [==[Sie versuchen in "%{name}" eine leere Modulsammlung zu speichern. Falls Sie dies wollen, verwenden Sie:
  $ module --force save %{name}
]==],
     w_SYS_DFLT_EMPTY      = [==[
Die Standard-Module des Systems enthalten keine Module.
  (Umgebungsvariable: LMOD_SYSTEM_DEFAULT_MODULES ist leer)
  Es wurden keine Änderungen der geladenen Module vorgenommen.
]==],
     w_System_Reserved     = "Die Bezeichnung \"system\" für Sammlungen ist reserviert. Bitte vergeben Sie einen anderen Namen.\n",
     w_Undef_MPATH         = "MODULEPATH ist nicht definiert.\n",
     w_Unknown_Hook        = "Unbekannter Hook: \"%{name}\"\n",

     --------------------------------------------------------------------------
     -- Usage Message
     --------------------------------------------------------------------------
     usage_cmdline         = "module [options] sub-command [args ...]",
     help_title            = "Unterbefehle für Hilfe:\n" ..
                             "------------------",
     help1                 = "Gibt diesen Text aus.",
     help2                 = "Gibt Hilfe-Text eines Moduls aus.",

     load_title            = "Unterbefehle zum Laden/Entladen:\n" ..
                             "-------------------------------",
     load1                 = "Lädt Module.",
     load2                 = "Lädt Module und zeige keine Fehlermeldungen, wenn sie nicht gefunden werden.",
     load3                 = "Entlädt Module und zeigt keine Fehlermeldungen, wenn sie nicht gefunden werden.",
     load4                 = "Entlädt \"m1\" und lädt \"m2\".",
     load5                 = "Entlädt alle Module.",
     load6                 = "Lädt alle Aliase der aktuellen Module neu.",
     load7                 = "Lädt alle geladenen Module neu.",

     list_title            = "Unterbefehle zum Anzeigen und Durchsuchen:\n" ..
                             "---------------------------------",
     list1                 = "Zeigt alle geladenen Module.",
     list2                 = "Zeigt alle geladenen Module, die zu dem Muster passen.",
     list3                 = "Zeigt alle verfügbaren Module.",
     list4                 = "Zeigt alle verfügbaren Module, die \"string\" enthalten.",
     list5                 = "Zeigt alle möglichen Module.",
     list6                 = "Zeigt alle verfügbaren Versionen des Moduls.",
     list7                 = "Zeigt alle Module die \"string\" enthalten.",
     list8                 = "Zeigt detaillierte Informationen zu dieser Version des Moduls.",
     list9                 = "Gibt alle \"whatis\"-Informationen zu einem Modul.",
     list10                = "Durchsucht alle \"name\" und \"whatis\" nach \"string\".",

     srch_title            = "Suchen mit Lmod:\n" ..
                             "--------------------",
     srch0                 = "  Alle Suchbefehle (spider, list, avail, keyword) unterstützen reguläre Ausdrücke:",
     srch1                 = "Findet alle Module, deren Name mit \"p\" oder \"P\" anfängt.",
     srch2                 = "Findet alle Module, die \"mpi\" in ihrem Namen enthalten.",
     srch3                 = "Findet alle Module, deren Name auf \"mpi\" endet.",

     collctn_title         = "Befehle zu Modulsammlungen:\n"..
                             "--------------------------------",
     collctn1              = "Speichert die geladenen Module in die Standard-Module des Nutzers (Sammlung mit dem Namen \"default\").",
     collctn2              = "Speichert die geladenen Module in der Sammlung \"name\".",
     collctn3              = "Das gleiche wie \"restore system\"",
     collctn4              = "Setzt die Module auf die Standard-Module des Nutzers (Sammlung mit dem Namen \"default\") oder des Systems zurück.",
     collctn5              = "Setzt die Module auf die Sammlung \"name\" zurück.",
     collctn6              = "Setzt die Module auf die Standard-Module des Systems zurück.",
     collctn7              = "Liste der gespeicherten Sammlungen.",
     collctn8              = "Beschreibt die Inhalte einer Modulsammlung.",
     collctn9              = nil,

     depr_title            = "Veraltete Befehle:\n" ..
                             "--------------------",
     depr1                 = "Lädt die angegebene Modulsammlung oder \"default\" des Nutzers, falls kein Name angegeben wird.",
     depr2                 = "===> Nutzen sie \"restore\" stattdessen  <====",
     depr3                 = "Speichert die aktuell geladenen Module unter dem angegebenen Namen. Falls kein Name angegeben ist, werden die Module als Standard für ihren Benutzer gespeichert.",
     depr4                 = "===> Nutzen Sie \"save\" stattdessen. <====",

     misc_title            = "Sonstige Unterbefehle:\n" ..
                             "---------------------------",
     misc1                 = "Zeigt die Befehle in der Modul-Datei.",
     misc2                 = "Voranstellen oder Anfügen eines Pfades zu MODULEPATH.",
     misc3                 = "Entfernt einen Pfad aus MODULEPATH.",
     misc4                 = "Ausgabe der aktiven Module als Lua-Liste.",


     env_title             = "Wichtige Umgebungsvariablen:\n" ..
                             "--------------------------------",
     env1                  = "Wenn dieser Wert auf \"YES\" festgelegt ist, wird Lmod Meldungen farbig ausgeben.",
     web_sites             = "Lmod-Webseiten",
     rpt_bug               = "  Um einen Fehler zu melden, lesen Sie bitte ",

     --------------------------------------------------------------------------
     -- module help strings
     --------------------------------------------------------------------------
     StickyM   = "Das Modul ist angeheftet. Verwenden Sie \"--force\", um das Modul zu entladen.",
     LoadedM   = "Modul ist geladen.",
     ExplM     = "Experimentell.",
     TstM      = "Testen.",
     ObsM      = "Obsolet.",

     help_hlp  = "Dieser Hilfetext",
     style_hlp = "Systemspezifischer \"avail\"-Stil: %{styleA} (Standard: %{default})",
     rt_hlp    = "Lmod Regressionstest",
     dbg_hlp   = "Programmablauf wurde nach \"stderr\" geschrieben.",
     pin_hlp   = "Beim Wiederherstellen von Modulen die angegebene Version nutzen und die Standard-Version ignorieren.",
     avail_hlp = "Zeigt Standard-Module nur in Verbindgung mit \"avail\".",
     quiet_hlp = "Zeigt keine Warnungen an.",
     exprt_hlp = "Experten Modus.",
     terse_hlp = "Aktiviert die maschinenlesbare Ausgabe für die Befehle: \"list\", \"avail\", \"spider\", \"savelist\".",
     initL_hlp = "Lädt Lmod zum ersten mal in eine Nutzer-Shell.",
     latest_H  = "Lädt die aktuellste Version eines Moduls ohne Beachtung von Standard-Modulen.",
     cache_hlp = "Behandelt die Cache-Dateien als veraltet.",
     novice_H  = "Schaltet die Experten- und Stille-Schalter ab.",
     raw_hlp   = "Gibt Modul-Dateien im Rohformat aus, wenn \"show\" verwendet wird.",
     width_hlp = "Nutzt diesen Wert als maximale Breite des Terminals.",
     v_hlp     = "Zeigt Versionsinformationen und beendet die Ausführung.",
     rexp_hlp  = "Verwendet reguläre Ausdrücke bei Vergleichen.",
     gitV_hlp  = "Gibt die git-Version in einem maschinenlesbarem Format aus und beendet die Ausführung.",
     dumpV_hlp = "Gibt die Version in einem maschinenlesbaren Format aus und beendet die Ausführung.",
     chkSyn_H  = "Überprüft die Modul-Befehls-Syntax. Lädt keine Module.",
     config_H  = "Zeigt die Lmod-Konfiguration.",
     jcnfig_H  = "Zeigt die Lmod-Konfiguration im JSON-Format.",
     MT_hlp    = "Zeigt den Status der Modul-Liste.",
     timer_hlp = "Zeigt Laufzeit an.",
     force_hlp = "Erzwingt das Entfernen von angehefteten Modulen oder das Speichern von leeren Sammlungen.",
     redirect_H= "Leitet die Ausgabe von \"list\", \"avail\", \"spider\" nach \"stdout\" um (nicht nach \"stderr\").",
     nrdirect_H= "Erzwingt die Ausgabe von \"list\", \"avail\", \"spider\" nach \"stderr\".",
     hidden_H  = "Avail und spider geben versteckte Module aus.",
     spdrT_H   = "Eine Auszeit für spider.",
     trace_T   = nil,
     

     Where     = "\n  Wo:\n",
     Inactive  = "\nInaktives Modul.",
     DefaultM  = "Standard Modul.",
     HiddenM   = "Verstecktes Modul.",

     avail     = [==[Verwenden Sie "module spider" um alle verfügbaren Module anzuzeigen.
Verwenden Sie "module keyword key1 key2 ...", um alle verfügbaren Module anzuzeigen, die mindestens eines der Schlüsselworte enthält.
]==],
     list      = " ",
     spider    = " ",
     aliasMsg  = "Ein Alias existiert: \"foo/1.2.3 (1.2)\" bedeutet, dass \"module load foo/1.2\" das Modul \"foo/1.2.3\" lädt.",
     noModules = "Es wurden keine Module gefunden!",
     noneFound = "  Nichts gefunden.",

     --------------------------------------------------------------------------
     -- Other strings:
     --------------------------------------------------------------------------
     coll_contains  = "Die Modulsammlung \"%{collection}\" enthält: \n",
     currLoadedMods = "Derzeit geladene Module",
     keyword_msg    = [==[
%{border}
Die folgenden Module stimmen mit Ihren Suchkriterien überein: "%{module_list}"
%{border}
]==],
     lmodSystemName = "(Für LMOD_SYSTEM_NAME = \"%{name}\")",
     matching       = " Passend: %{wanted}",
     namedCollList  = "Liste benannter Sammlungen %{msgHdr}:\n",
     noModsLoaded   = "Es sind keine Module geladen.\n",
     specific_hlp   = "Modul-spezifische Hilfe für \"%{fullName}\".",
   }
}

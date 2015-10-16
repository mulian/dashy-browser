# TODO

## App Tabs überarbeiten
### Grundlegende änderungen
* Jede aufgerufene app bekommt eine Feste ID und wird ggf. nur wieder angezeigt.
* Jede Über google geöffnete App ist Frei (ungebunden) und wird nicht wieder gefunden
### Inhalt des App-Menus
* Alle apps (ähnlich zu Tabs im Browser)
* Google Suche?
* Daisy Beenden hinzufügen?
* Vor-/Rück-wärts navigieren
* aktuelle URL **nur anzeige**

## Apps
### Schnittstelle
Alle apps bekommen eine FileSave Libary, die durchgereicht wird an Daisy
* saveFile(app_name,data)
* Promt: fileName
### Summo (flash)
* Wenn bestimmte URL erreicht
  * Triggert daisy->uploadLink(aktuelle_url)
### strut.io
* Nutzt Schnitstellen FileSave Lib.
### Marvel
* TODO: Prüfen


# Erledigt

## Desktop Ordner
Für MS Office, im speziellen Visio.
* Desktop Ordner "upload"
  * wird mit der Applikation erstellt
  * alles was da rein kommt wird hochgeladen
    * daisy->uploadFile(appname,url,gruppen_id=null)
      * appname wird an endung erkannt
  * und mit schließen von Electron gelöscht

(REMOVED: "favicon": ">=0.0.2",)

## ein/ausblenden
### Was soll es können? - "fertig"
Wenn eine Andere Applikation geöffnet ist:
  * Wird mit einem "swypw" von ganz links nach rechts das Menu von Daisy eingeblendet
    * Beim Tippen auf das Menu:
      * verschwindet die aktuelle app im Hintergrund
        * Menu punkt wird erweitert mit "zurück zu xxx App"
          * Daraufhin soll die app wieder in den vordergrund
      * Der entsprechende Menu Punkt wird aufgerufen
### Daisy ein/ausblenden
Bei einem swype von ganz links zur mitte (bzw. rechts), wird Daisy angezeigt.
### App Menu ein/ausblenden
Beim swype von ganz rechts zur mitte (bzw. links), wird ein App Menu angezeigt.

## Notifications - fertig
* Es wird ein Notifications Center erstellt.
* An den kann ein text gesendet werden
  * dieser wird 5-10sec angezeigt
  * dann ausgeblendet

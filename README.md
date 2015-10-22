# daisy-browser (Dashboard Browser)

## [Documentationen](http://rawgit.com/mulian/daisy-browser/master/docs/app-list.html)

## Flash
change package.json -> **flash.path** and **flash.version** with your installed chrome Browser's Version (chrome://plugins/).
Note: This will currently not work with Electron- Windowsx64 Build. Only with ia32.

## Settings
Hier finden sie die Informationen welche einstellungen bei package.json > Settings gemacht werden können.
### Debug
Wenn Settings.debug true ist, wird die console geöffnet und coffescript+less compiliert.
Wichtig: Dies muss beim ersten Applikations start auf true stehen!
### Url
Die Url der Haupt Applikation.
### Zeige Demo
Wenn settings.showIntroduction==true, wird die Finger-Demo und eine Nachricht zum Dateiupload angezeigt.
### Dir Upload
Deaktiviert den Upload wenn settings.dirUpload.enable=false.
Mit settings.dirUpload.dir wird der Überordner des up-/download Ordners angegeben.
### Nativ Apps
Hier werden die Nativen Applikations Dateien hinterlegt. Die Haupt App wird <call_name>: ausführen.
Jeder eintrag sieht so aus: 'call_name' : 'run_file_path'

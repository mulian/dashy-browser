# directory-upload.coffee
# Beim oeffnen von Dashy wird auf dem Desktop (settings.dirUpload.dir) ein Upload Ordner erstellt.
# Wenn dem Ordner eine Datei hinzugefuegt wird,  wird sie Automatisch hochgeladen.

{settings} = require '../package.json'
fs = require 'fs'
isTextOrBinary = require('istextorbinary')

module.exports =
class DirectoryUpload
  uploadDir: null
  constructor: ->
    @uploadDir = settings.dirUpload.dir
    @createSubDir()
    @watch()

  #Loescht das upload Verzeichnis. Wird aber nicht ausgefuert.
  #Die Funktion kann noch nutzen bringen, deswegen wird sie nicht geloescht.
  deconstructor: ->
    @rmSubDir()
    @unWatch()

  #### Erstellen und Loeschen

  # Erstellt das Upload Verzeichnis, falls noch nicht vorhanden
  createSubDir: ->
    @uploadDir = "#{@uploadDir}/upload"
    # console.log "upload Dir: #{@uploadDir}"
    if settings.showIntroduction
      setTimeout ->
        eventbus.fire "Notifications","info","Wenn Sie eine Office-/Text-Datei zu dem Desktop-Ordner 'upload' hinzfügen, wird diese Datei automatisch zur ihren Account hinzugefügt. Wenn sie Eingeloggt sind."
      , 10*1000
    if not fs.existsSync @uploadDir
      fs.mkdirSync @uploadDir
  # Loescht das Upload Verzeichnis
  rmSubDir: ->
    fs.rmdirSync @uploadDir

  #### Beobachten

  # Beaobachtet das Upload Verzeichnis und fuert ggf. onDirChange aus
  watch: ->
    @watch = fs.watch @uploadDir, @onDirChange
  # Beobachtet das Verzeichnis nicht mehr. ;)
  unWatch: ->
    @watch.close()

  #### Aktionen nach dem eine Datei hinzugefuegt wurde.

  #Wenn sich etwas am Ordner veraendert hat.
  onDirChange: (event,filename) =>
    @upload filename

  #Lade die Datei ueber Daisy hoch
  upload: (filename) ->
    filePath = "#{@uploadDir}\\#{filename}"
    if fs.existsSync filePath
      # if isTextOrBinary.isTextSync filePath
      content = fs.readFileSync "#{@uploadDir}\\#{filename}",'utf8'
      file = @splitFileName filename

      # eventbus.fire "Notifications","info", "Die Datei #{filename} wird hochgeladen."
      window.eventbus.fire 'MainApp','uploadFile', {} =
        appName: file.type
        url: 'none'
        data: content
        filename: file.name
        type: file.type
      # else
      #   eventbus.fire "Notifications","info","Die Datei '#{filename}' ist keine Text-/Office-Datei."
      #   eventbus.fire "Notifications","info","Bild Datein und andere Binary Dateien können über 'Daisy->Dateien->Neue Datei anlegen' hochgeladen werden."

  #Teile den Dateinamen in name und type auf.
  splitFileName: (filename) ->
    re = /^([\w_\-\.\$#&@!\(\)\{\}'~^\s]+)\.([\w]+)$/
    file = re.exec filename
    if file
      return {} =
        name: file[1]
        type: file[2]
    else
      return {} =
        name: filename
        type: 'undefined'

#Main JS from Electron-Browser

app = require 'app'
# Module to control application life.
BrowserWindow = require 'browser-window'
# Module to create native browser window.
fs = require 'fs'
packageFile = require '../package.json'

{settings} = require '../package.json'

{exec} = require 'child_process'

# Report crashes to our server.
# require('crash-reporter').start()
# Keep a global reference of the window object, if you don't, the window will
# be closed automatically when the JavaScript object is garbage collected.
mainWindow = null
app.commandLine.appendSwitch 'ppapi-flash-path', packageFile.flash.path
app.commandLine.appendSwitch 'ppapi-flash-version', packageFile.flash.version
# Quit when all windows are closed.
app.on 'window-all-closed', ->
  # On OS X it is common for applications and their menu bar
  # to stay active until the user quits explicitly with Cmd + Q
  if process.platform != 'darwin'
    app.quit()

# This method will be called when Electron has finished
# initialization and is ready to create browser windows.
# console.log "funzt"
app.on 'ready', ->
  # Create the browser window.
  console.log "#{__dirname}/gfx/Dashy.ico"
  mainWindow = new BrowserWindow {} =
    width: 1920
    height: 1080
    fullscreen: true
    icon: "#{__dirname}/../gfx/Dashy.ico"
    'web-preferences': 'plugins': true
    'always-on-top' : false
  webContents = mainWindow.webContents
  webContents.enableDeviceEmulation fitToView: true
  mainWindow.loadUrl('file://' + __dirname + '/../index.html');

  # Open the DevTools.
  mainWindow.openDevTools() if settings.debug
  session = webContents.session
  executeFile = (path) ->
    # console.log path
    path = "open #{path}" if process.platform == 'darwin'
    exec path, (error, stdout, stderr) ->
      console.log "stdout: #{stdout}"
      console.log "stderr: #{stderr}"
      if error?
        console.log "exec error: #{error}"
        webContents.send "error","Beim ausführen von #{path}."
      else
        webContents.send "info","Datei #{path} wird ausgeführt."
  session.on 'will-download', (event, item, downloadWebContents) ->
    downloadFolder = "#{settings.dirUpload.dir}/download"
    item.on 'done', (e, state) ->
      if (state == "completed")
        webContents.send "info", "#{item.getFilename()} erfolgreich heruntergeladen."
        console.log("Download successfully");
        executeFile "#{downloadFolder}/#{item.getFilename()}"
      else
        webContents.send "error", "beim herunterladen von #{item.getFilename()}."
    if not fs.existsSync downloadFolder
      fs.mkdirSync downloadFolder
    item.setSavePath "#{downloadFolder}/#{item.getFilename()}"
    # console.log 'DOWNLOAD: ' + item.url
    webContents.send "closeCurrentWindow"
    # webContents.executeJavaScript 'window.eventbus.on("AppManager","closeCurrentWindow");'
    # event.preventDefault()
  mainWindow.on 'closed', ->
    # Dereference the window object, usually you would store windows
    # in an array if your app supports multi windows, this is the time
    # when you should delete the corresponding element.
    mainWindow = null

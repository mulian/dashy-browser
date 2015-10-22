#main.coffee
#Main JS from Electron-Browser

app = require 'app'
BrowserWindow = require 'browser-window'
fs = require 'fs'
{exec} = require 'child_process'

packageFile = require '../package.json'
settings = packageFile.settings

# Report crashes to our server.
require('crash-reporter').start();

# Report crashes to our server.
# require('crash-reporter').start()
# Keep a global reference of the window object, if you don't, the window will
# be closed automatically when the JavaScript object is garbage collected.
mainWindow = null
# require "C:\\Users\\wii\\AppData\\Local\\Google\\Chrome\\User\ Data\\PepperFlash\\19.0.0.226\\manifest.json"

# initiate Flash
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
  mainWindow = new BrowserWindow {} =
    width: 1920
    height: 1080
    # fullscreen: true
    icon: "#{__dirname}/../gfx/Dashy.ico"
    plugins: true
    'web-preferences':
      plugins: true
    'always-on-top' : false
  webContents = mainWindow.webContents
  webContents.enableDeviceEmulation fitToView: true
  mainWindow.loadUrl('file://' + __dirname + '/../index.html');

  # Open the DevTools.
  mainWindow.openDevTools() if settings.debug
  session = webContents.session

  #execute a Native File
  executeFile = (path) ->
    path = "open #{path}" if process.platform == 'darwin'
    exec path, (error, stdout, stderr) ->
      console.log "stdout: #{stdout}"
      console.log "stderr: #{stderr}"
      if error?
        console.log "exec error: #{error}"
        webContents.send "error","Beim ausführen von #{path}."
      else
        webContents.send "info","Datei #{path} wird ausgeführt."

  # on file Download
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

    webContents.send "closeCurrentWindow"

  # on Window Close
  mainWindow.on 'closed', ->
    # Dereference the window object, usually you would store windows
    # in an array if your app supports multi windows, this is the time
    # when you should delete the corresponding element.
    mainWindow = null

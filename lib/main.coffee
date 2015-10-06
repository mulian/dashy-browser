#Main JS from Electron-Browser

app = require 'app'
# Module to control application life.
BrowserWindow = require 'browser-window'
# Module to create native browser window.
fs = require 'fs'
packageFile = require '../package.json'

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
  mainWindow = new BrowserWindow {} =
    width: 800
    height: 600
    'web-preferences': 'plugins': true
  webContents = mainWindow.webContents
  webContents.enableDeviceEmulation fitToView: true
  mainWindow.loadUrl('file://' + __dirname + '/../index.html');

  # Open the DevTools.
  mainWindow.openDevTools()
  session = webContents.session
  session.on 'will-download', (event, item, webContents) ->
    console.log 'DOWNLOAD: ' + item.url
    event.preventDefault()
  mainWindow.on 'closed', ->
    # Dereference the window object, usually you would store windows
    # in an array if your app supports multi windows, this is the time
    # when you should delete the corresponding element.
    mainWindow = null

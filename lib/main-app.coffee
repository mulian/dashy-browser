#main-app.coffee
App = require './app'
fs = require 'fs'

# The Main App for AppManager
module.exports =
class MainApp extends App

  #### Initial Funktionen

  # Constructor
  # * `options` {Object}
  #   * `name` {String} the name of app (like id)
  #   * `on' {Object}
  #     * `newWindow` {Function}
  #       * `event` {Object}
  #     * `log` {Function}
  #       * `event` {Object}
  #     * `finishLoad` {Function}
  #       * `event` {Object}
  constructor: (options={}) ->
    {@on,@name} = options
    options.withPlugins = false
    # options.nodeintegration=true
    super options
    # @initElements()
    window.eventbus.on 'MainApp','uploadFile', @uploadFile

  # Fügt Folgendes JS zur Daisy App hinzu.
  getPreload: ->
    # './src/daisy-execute.js'
    './src/daisy-interface.js'

  initialize: ->
    super
    @regEvents()
    @changeId @name,true
    @entryClose.remove() if @entryClose?

  # Registriert die App-Events
  regEvents: ->
    @dom.addEventListener 'new-window', @on.newWindow if @on.newWindow
    if @on.log
      @dom.addEventListener 'console-message', @on.log
    else @dom.addEventListener 'console-message', @log
    @dom.addEventListener 'did-frame-finish-load', @finishLoad
    @dom.addEventListener 'ipc-message', @ipcMsg

  #### IPC

  # Bekomme die Nachricht, uploadReady
  ipcMsg: (event) =>
    if event.channel == 'uploadReady'
      # console.log event
      filename = event.args[0].filename
      if event.args[0].return.status == 'Heilige Mutter Teresa' # aka. successfully
        eventbus.fire "Notifications","info","Die Datei #{filename} wurde erfolgreich Hochgeladen, falls sie Eingeloggt sind."
      else
        eventbus.fire "Notifications","error","Die Datei #{filename} konnte nicht hochgeladen werden."

  # sende etwas zur App
  ipcSend: (channel,args) ->
    @dom.send channel,args

  # Lade Datei hoch
  uploadFile: (options) =>
    {appName,url,data,fileName,type} = options
    @ipcSend 'upload', options

  # Pipt die App Logs zur Haupt App
  loginRE: /^user_id:(\d+)$/
  log: (e) =>
    # console.log("#{@name}: #{e.message}")
    if match = @loginRE.exec e.message
      console.log match
      id=match[1]
      console.log id
      eventbus.fire 'Login','setId',parseInt id
      # console.log "logged in! with id:#{id}"
  # finishLoad: (event, isMainFrame) =>
  #   console.log "finished loading"

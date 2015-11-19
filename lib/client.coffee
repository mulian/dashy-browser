#client.coffee
#Wird von der index.html eingebunden

$ = jQuery = require 'jquery'
AppManager = require './src/app-manager'
View = require './src/view'
EventBus = require './src/event-bus'
Notifications = require './src/notifications'
DirectoryUpload = require './src/directory-upload'
ipc = require 'ipc'
Login = require './src/login'

require 'smart-touch'
# require '/Users/maxh/Workspaces/Projekte/Andere/smart-touch'
# console.log window.touch

class Client extends View
  constructor: ->
    super
    window.eventbus = new EventBus()
    new Notifications()
    @appManager = new AppManager()
    @directoryUpload = new DirectoryUpload()
    @regIPC()
    new Login()


  #Registriere die IPC Calls die von aussen (App Schale) kommen koennen
  regIPC: ->
    ipc.on 'closeCurrentWindow', ->
      window.eventbus.fire "AppManager","closeCurrentWindow"
    ipc.on 'info', (msg) ->
      window.eventbus.fire "Notifications","info", msg
    ipc.on 'error', (msg) ->
      window.eventbus.fire "Notifications","error", msg

  # Wird bei jedem 'resize' event aufgerufen und am anfang.
  resize: ->
    @body = $('body') if not @body?
    @body.width $(window).width()
    @body.height $(window).height()

#Startet sich selbst nach aufruf.
new Client()

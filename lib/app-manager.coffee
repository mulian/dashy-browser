# Managed die Apps

View = require './view'
{settings} = require '../package.json'
MainApp = require './main-app'
AppList = require './app-list'
ShowTouch = require './show-touch'
SumoSave = require './sumo-save'
NativeAppStarter = require './native-app-starter'

module.exports =
class AppManager
  mainApp: null
  currentApp: null

  #### Initial Funktionen

  constructor: ->
    @mainApp = new MainApp
      name: 'daisy'
      src: settings.url
      on:
        newWindow: @newApp
    @currentApp = @mainApp
    @appList = new AppList()
    @appList.setMainApp @mainApp
    @showTouch = new ShowTouch()
    @reqEventBus()
    @startPlugins()

  #registriere Funktionen beim EventBus
  reqEventBus: ->
    window.eventbus.on "AppManager","changeApp", @changeApp
    window.eventbus.on "AppManager","closeCurrentWindow", @closeCurrentWindow
    window.eventbus.on "AppManager","closeWindow", @closeWindow

  #Starte Plugins
  startPlugins: ->
    @sumoSave = new SumoSave()
    @nativeAppStarter = new NativeAppStarter()

  #### EventBus Funktionen

  #Wechselt die app. Versteckt die aktuelle und macht die neue Sichtbar.
  changeApp: (app) =>
    @currentApp.entry.removeClass('active')
    @currentApp.element.hide()
    app.entry.addClass('active')
    app.element.show()
    @currentApp = app

  #Schliesst eine App.
  closeWindow: (app) =>
    if app.src == @mainApp.src
      window.eventbus.fire "Notifications","error","Die Hauptapplikation kann nicht geschlossen werden."
    else
      @appList.remove app
      app.element.remove()
      window.eventbus.fire "AppManager","changeApp", @mainApp

  #Schliesst die aktuelle App.
  closeCurrentWindow: =>
    @closeWindow @currentApp

  #### Andere

  #Erstellt eine Neue App, wenn es eine richtige URL ist. Falls es eine Nativ App Starter Url ist, oeffne die Native App.
  firstTime : true
  newApp: (event) =>
    nativeRE= /^([\w]*):$/
    # console.log @appList
    window.eventbus.fire "AppManager","newApp",event.url
    if not nativeRE.test event.url
      @appList.add event.url
      if @firstTime
        @firstTime=false
        @showTutorial()

  #Zeigt das ShowTouch (aka. Tutorial) an
  showTutorial: ->
    setTimeout ->
      window.eventbus.fire 'ShowTouch','menu'
    , 3*1000

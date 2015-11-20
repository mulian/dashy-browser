# Managed die Apps

View = require './view'
{settings} = require '../package.json'
MainApp = require './main-app'
AppList = require './app-list'
ShowTouch = require './show-touch'
SumoSave = require './sumo-save'
NativeAppStarter = require './native-app-starter'
ProwisePlugin = require './prowise-plugin'

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
    touch.on().pinch.in().fingers.betweene(4,10).call @pinchIn

  # TODO: TEST
  _maxPitch: 999
  _lastPercent: 100
  _start: false
  pinchIn: (e) =>
    console.log "pinch in?"
    console.log e
    if e.start and not @mainApp.is(':visible') and not @_start
      @_start=true
      @mainApp.show()
      @_maxPitch = e.avg.pitch
      @_lastPercent= 100
    if @_start
      e.preventDefault()
      if not e.end?
        percent = (e.avg.diff.pitch*-1)/(@_maxPitch/100)
        @_lastPercent=percent if e.touches.length>=4
        if @_lastPercent<80
          @mainApp.css 'left',"#{@_lastPercent-80}%"
        else @mainApp.css 'left',"0px"
      else #aka. on e.end==ture
        @_start=false
        @mainApp.css 'left',"0px"
        if @_lastPercent>60
          @closeCurrentWindow()
        else
          @mainApp.hide()

  #registriere Funktionen beim EventBus
  reqEventBus: ->
    window.eventbus.on "AppManager","changeApp", @changeApp
    window.eventbus.on "AppManager","closeCurrentWindow", @closeCurrentWindow
    window.eventbus.on "AppManager","closeWindow", @closeWindow

  #Starte Plugins
  startPlugins: ->
    @sumoSave = new SumoSave()
    @nativeAppStarter = new NativeAppStarter()
    @prowisePlugin = new ProwisePlugin()

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
    # window.eventbus.fire "AppManager","newApp",event.url
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

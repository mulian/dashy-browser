# Manage AppList, Open/Close, Show Menu

#### Imports
# View calls initialize on dom ready
View = require './view'
# Use Settings from package.json
{settings} = require '../package.json'
# Main Applikation
MainApp = require './main-app'
App = require './app'
AppList = require './app-list'
GestureSide = require './gesture-side'
ShowTouch = require './show-touch'
SumoSave = require './sumo-save'
StrutSave = require './strut-save'
NativeAppStarter = require './native-app-starter'

#### Class AppManager
module.exports =
class AppManager extends View
  mainApp: null
  currentApp: null
  constructor: ->
    super
    @mainApp = new MainApp
      name: 'daisy'
      src: settings.url
      on:
        newWindow: @newApp
    @currentApp = @mainApp
    @appList = new AppList()
    @appList.setMainApp @mainApp
    @showTouch = new ShowTouch()
    window.eventbus.on "AppManager","changeApp", @changeApp
    @startPlugins()

    # window.eventbus.on "App","entryClick",@onClickApp
    # window.eventbus.on 'AppManager','newApp',@newApp

  startPlugins: ->
    @sumoSave = new SumoSave()
    @strutSave = new StrutSave()
    @nativeAppStarter = new NativeAppStarter()

  initialize: ->
    @gesture = new GestureSide
      space: settings.guesture.space
      minActivate: settings.guesture.minActivate
      on:
        left: @onLeft
        right: @onRight
    # @showTouch.showLeftAndRight()

  leftAction: false
  onLeft: (event) =>
    if not @mainApp.element.is(":visible") or @leftAction
      @leftAction=true
      event.preventDefault()
      # @mainApp.dom
      left = event.left-@mainApp.element.width()
      left += event.left*3
      left = 0 if left>0
      @mainApp.element.show()
      @mainApp.element.css('left',left)
      if event.end
        if event.left>=80
          @mainApp.element.removeAttr( 'style' );
          @changeApp @mainApp
        else
          @mainApp.element.hide()
        @leftAction=false


  onRight: (event) =>
    # if not @appList.dom.is(":visible")
    if @appList.list.length>0
      event.preventDefault()
      # console.log @appList.dom.width()
      right = event.right-@appList.dom.width()
      right = right+event.right*3
      right = 0 if right>0
      # console.log right
      @appList.dom.show()
      @appList.dom.css('right',right)
      if event.end
        if event.right > 80
          @appList.dom.removeAttr('style')
        else @appList.dom.hide()

  changeApp: (app) =>
    @currentApp.entry.removeClass('active')
    @currentApp.element.hide()
    app.entry.addClass('active')
    app.element.show()
    @currentApp = app

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

  showTutorial: ->
    setTimeout ->
      window.eventbus.fire 'ShowTouch','left'
      setTimeout ->
        window.eventbus.fire 'ShowTouch','right'
      , 7*1000
    , 3*1000

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
Gesture = require './gesture'

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

  initialize: ->
    console.log "jo"
    @gesture = new Gesture
      space: settings.guesture.space
      minActivate: settings.guesture.minActivate
      on:
        left: @onLeft
        right: @onRight

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
          @currentApp.element.hide()
        else
          @mainApp.element.hide()
        @leftAction=false


  onRight: (event) =>
    if not @appList.dom.is(":visible")
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


  newApp: (event) =>
    @mainApp.element.hide()
    @currentApp = @appList.add event.url

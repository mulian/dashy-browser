App = require './app'
$ = jQuery = require 'jquery'
View = require './view'
GestureItem = require './gesture-item'
{settings} = require '../package.json'

module.exports =
class AppList extends View
  list: []
  dom: null
  constructor: ->
    super
    window.eventbus.on "AppManager","changeApp", (app) =>
      @currentApp = app
      # console.log @currentApp
      # if @currentApp.dom?.canGoBack()
      #   @back.removeAttr 'disabled'
      # else @back.attr 'disabled','true'
      # if @currentApp.dom?.canGoForward()
      #   @forward.removeAttr 'disabled'
      # else @forward.attr 'disabled','true'


  initialize: ->
    @dom = $ '<div />', {} =
      id: 'app_liste'
    @dom.hide()
    @initNavigation()
    @domList = $('<ul />')
    @dom.append @domList
    $('body').append @dom

    @mainApp.entry.attr 'id','listMainApp'
    @domList.append @mainApp.entry

    @gesture = new GestureItem
      space: settings.guesture.space
      minActivate: settings.guesture.minActivate
      element : @dom[0]
      moveY: @moveY

  remove: (app) ->
    # console.log "remove!"
    for item, pos in @list
      if app.src == item.src
        # console.log "find: remove! #{pos} with src: #{item.src}"
        app.entry.remove()
        @list.splice pos,1
        return

    console.log "there is no app to close"

  moveY: (event) =>
    # console.log "moveX"
    # console.log event
    console.log "moveY"
    @dom.css 'top',"#{event.diff.top}px"
    if event.end
      if event.top <= 200
        #hide
        @dom.hide()
      else
         @dom.removeAttr 'style'
    # @dom.css 'right',@dom.css('right')+event.diff.right

  setMainApp: (@mainApp)->

  isAppInAppList: (url) ->
    for item in @list
      if item.getSrcId() == url
        return item
    return false

  initNavigation: ->
    @navigation = $ '<div />', {} =
      id: 'appListNavigation'
    @back = $ '<button />', {} =
      text: 'Zurück'
      # 'disabled': 'true'
    @forward = $ '<button />', {} =
      text: 'Vor'
      # 'disabled': 'true'
    @back.click =>
      # console.log "ZURÜCK #{@currentApp.name}"
      @currentApp.dom.goBack()
    @forward.click =>
      @currentApp.dom.goForward()

    @initEndButton()
    @navigation.append @back
    @navigation.append @forward
    @dom.append @navigation

  initEndButton: ->
    @endButton = $ '<button />', {} =
      text: 'Beenden'
      id: 'end'
    @endButton.click ->
      window.close() #TODO: Nur die Seite ist geschlossen?
    @dom.append @endButton

  add: (url) ->
    app = @isAppInAppList(url)
    if app==false
      app = new App {src: url}
      @list.push app
      @domList.append app.entry
      # console.log name
    window.eventbus.fire "AppManager","changeApp",app

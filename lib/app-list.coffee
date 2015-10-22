App = require './app'
$ = jQuery = require 'jquery'
View = require './view'
# GestureItem = require './gesture-item'
{settings} = require '../package.json'
# TouchGesture = require './touch-gesture'

Touch = require './touch'

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
    @initEndButton()

    console.log touch.on(document.body).fingers.eq(3).call(@touchDown)
    # @gesture = new GestureItem
    #   space: settings.guesture.space
    #   minActivate: settings.guesture.minActivate
    #   element : @dom[0]
    #   moveX: @moveX
    # @touch = new TouchGesture {} =
    #   onThreeTouch: @touch

  lastRight: null
  touchDown: (e) =>
    if not e.end
      @dom.show()
      width = @dom.width()
      right = e.avg.diff.x*-1 - width
      if right<0 and right>width*-1
        @dom.css 'right',"#{right}px"
      else if right>0
        @dom.css 'right',"0px"

      @lastRight = right

    else
      console.log @lastRight
      if (@lastRight*-1)/2 > (width/2)
        @dom.css 'right',"0px"
      else
        @dom.hide()



  remove: (app) ->
    # console.log "remove!"
    for item, pos in @list
      if app.src == item.src
        # console.log "find: remove! #{pos} with src: #{item.src}"
        app.entry.remove()
        @list.splice pos,1
        return

    console.log "there is no app to close"

  moveX: (event) =>
    # console.log "moveX"
    # console.log event

    @dom.css 'right',"#{event.diff.right}px"
    if event.end
      if event.right <= 200
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

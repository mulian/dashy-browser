App = require './app'
$ = jQuery = require 'jquery'
View = require './view'

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
    @dom.append @endButton

  add: (url) ->
    app = @isAppInAppList(url)
    if app==false
      app = new App {src: url}
      @list.push app
      @domList.append app.entry
      # console.log name
    window.eventbus.fire "AppManager","changeApp",app

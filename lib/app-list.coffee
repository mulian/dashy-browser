App = require './app'
$ = jQuery = require 'jquery'
View = require './view'

module.exports =
class AppList extends View
  list: []
  dom: null
  constructor: ->
    super

  initialize: ->
    @dom = $ '<div />', {} =
      id: 'app_liste'
    @dom.hide()
    @domList = $('<ul />')
    @dom.append @domList
    $('body').append @dom

  isAppInAppList: (url) ->
    for item in @list
      if item.getSrcId() == url
        return item
    return false

  add: (url) ->
    app = @isAppInAppList(url)
    if app==false
      app = new App {src: url}
      @list.push app
      @domList.append app.entry
      # console.log name
    window.eventbus.fire "AppManager","changeApp",app

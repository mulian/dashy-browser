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

  isNameInAppList: (name) ->
    for item in @list
      if item.name == name
        return item
    return false

  add: (url) ->
    urlSplit = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?/.exec(url)
    console.log "ERROR on newApp-> urlSplit" if not urlSplit?
    name = urlSplit[2]

    if @isNameInAppList(name)==false
      app = new App
        name: name
        src: url
      @list.push app
      @domList.append app.entry
      # console.log name
    else
      app = @isNameInAppList(name)
      app.element.show()
    return app

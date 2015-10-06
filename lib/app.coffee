View = require './view'
$ = jQuery = require 'jquery'
favicon = require('favicon');

module.exports =
class App extends View
  constructor: ({@name,@src,@withPlugins=true}) ->
    @id = "app_#{@name}"
    super
    @setFavIcon()

  initialize: ->
    @getOrCreateElement()
    @createEntry()

  setFavIcon: ->
    favicon @src, (err, favicon_url) =>
      @favIcon = favicon_url
      # console.log @favIcon
      if @entry?
        fav = $ '<img />', {} =
          src: @favIcon
        @entry.prepend fav

  createEntry: ->
    @entry = $('<li />')
    if @favIcon?
      fav = $ '<img />', {} =
        src: @favIcon
    name = $ '<span />', {} =
      text: @name

    @entry.append fav
    @entry.append name

  #search for app or create if not exist
  getOrCreateElement: ->
    @element = $ "##{@id}"
    if not @element[0]? #if there is no with app id on dom
      @element = $ "<webview />", {} =
        id : @id
        class : "app"
        src : @src
      $('body').prepend @element #add to Dom
    else #check src, class
      @element.attr('src',@src) if not @element.attr('src')?
      @element.addClass 'app' if not @element.hasClass 'app'
    @element.attr('plugins','') if @withPlugins
    @dom = @element[0]

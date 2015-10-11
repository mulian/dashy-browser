View = require './view'
$ = jQuery = require 'jquery'
FavTitle = require('favicon');

module.exports =
class App extends View
  constructor: ({@name,@src,@withPlugins=true}) ->
    @setNameByUrl(@src) if not @name?
    @setId()
    super

  setId: (name=@name) ->
    @id = "app_#{name}"

  setNameByUrl: (url) ->
    console.log url
    urlSplit = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?/.exec(url)
    console.log "ERROR on newApp-> urlSplit" if not urlSplit?
    @name = urlSplit[2]

  initialize: ->
    @getOrCreateElement()
    @createEntry()
    @dom.addEventListener 'did-finish-load', @loading

  loading: =>
    @changeUrl @element.attr('src')
  changeUrl: (url) ->
    @name = @setNameByUrl url
    @changeId()
    @url = url
    @setFavIcon url
  changeId: (name=@name) ->
    @id = "app_#{@name}"
    @element.attr 'id',@id
    @entryName.text @name
  setFavIcon: (src=@src) ->
    FavTitle src, (err, favicon_url,title) =>
      # console.log @favIcon
      if @entry?
        @entryName.text title if title.length>0
        if not @favIcon?
          @favIcon = $ '<img />', {} =
            src: favicon_url
          @entry.prepend @favIcon
        else
          @favIcon.attr 'src', favicon_url


  createEntry: ->
    @entry = $('<li />')
    if @favIcon?
      fav = $ '<img />', {} =
        src: @favIcon
    @entryName = $ '<span />', {} =
      text: @name

    @entry.append fav
    @entry.append @entryName
    @entry.click =>
      window.eventbus.fire "AppManager",'changeApp',@

  #search for app or create if not exist
  getOrCreateElement: ->
    @element = $ "##{@id}"
    if not @element[0]? #if there is no with app id on dom
      @element = $ "<webview />", {} =
        id : @id
        class : "app"
        src : @src
        preload: @getPreload() if @getPreload?
      $('body').prepend @element #add to Dom
    else #check src, class
      @element.attr('preload',@getPreload()) if @getPreload?
      @element.attr('src',@src) if not @element.attr('src')?
      @element.addClass 'app' if not @element.hasClass 'app'
    @element.attr('plugins','') if @withPlugins
    @dom = @element[0]

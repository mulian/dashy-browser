$ = jQuery = require 'jquery'
View = require './view'
favicon = require 'favicon'
{settings} = require '../package.json'

module.exports =
class App extends View

  #### Initial Funktionen

  # Constructor
  # * obj {Object}
  #   * src {String}: Die Source URL
  #   * withPlugins {Boolean}: True falls die App Flash benutzt
  #   * reUse {Boolean}: Soll der Tab wieder benutzt werden, falls noch mal die gleiche src aufgerufen wird?
  #   * nodeintegration: Mit Nodeintegration
  constructor: ({@src,@withPlugins=true,@reUse=true,@nodeintegration=false}) ->
    @setId()
    @firstSrc=@src
    super

  initialize: ->
    @getOrCreateElement()
    @createEntry()
    @dom.addEventListener 'did-finish-load', @afterPageLoad
    @dom.addEventListener 'plugin-crashed', @onCrash if @withPlugins
    # Für das Debuggen von jedem Tab:
    @dom.addEventListener "dom-ready", =>
      @dom.openDevTools() if settings.debug

  #Gibt eine Information herraus, dass Flash abgestuerzt ist.
  onCrash: (event) ->
    window.eventbus.fire "Notifications",'error', "Flash ist abgestürtzt. Die Seite wird neu geladen."
    @dom.reload()

  #Nach jedem Seiten Laden
  afterPageLoad: (event) =>
    @changeUrl @dom.getUrl()
    @setName @dom.getTitle()
    window.eventbus.fire "App","afterPageLoad", @

  ####Setter und Getter

  #Setzt die ID anhand des @src Attributs
  setId: (preId=@src) ->
    preId=preId.replace /:/g,'_'
    .replace /\//g,'-'
    .replace /&/g,'-'
    .replace /\?/g,'_'
    .replace /\=/g,'_'
    .replace /\./g,'-'
    .replace /%/g,'-'
    @id = "app_#{preId}"

  #Gibt die Url zurück, falls @reUse
  getSrcId: ->
    if @reUse
      return @firstSrc
    else return @url

  setName: (name=@name) ->
    @name = name
    @entryName.text @name
  changeUrl: (url) ->
    @changeId()
    @url = url
    @setFavIcon url
  changeId: (preId=@src,force=false) ->
    if not @reUse or force
      @setId preId
      @element.attr 'id',@id

  setFavIcon: (src=@src) ->
    favicon src, (err, favicon_url,title) =>
      # console.log @favIcon
      if @entry?
        # @entryName.text title if title.length>0
        if not @favIcon?
          @favIcon = $ '<img />', {} =
            src: favicon_url
          @entry.prepend @favIcon
        else
          @favIcon.attr 'src', favicon_url

  #### Create Funktionen

  #Erstellt den eintrag fuer die App-Liste
  createEntry: ->
    @entry = $('<li />')
    if @favIcon?
      fav = $ '<img />', {} =
        src: @favIcon
    @entryName = $ '<span />', {} =
      text: @name
      class: "title"
    @entryClose = $ '<span />', {} =
      class: 'closeBtn'
      text: "X"
    @entry.append fav
    @entry.append @entryName
    @entry.append @entryClose
    @entry.click =>
      window.eventbus.fire "AppManager",'changeApp',@
      eventbus.fire "AppList","close"
    @entryClose.click =>
      window.eventbus.fire "AppManager","closeWindow", @

  # Sehr wichtige Funktion.
  # Erstellt eine App anhand seiner gesetzten eigenschaften
  getOrCreateElement: ->
    @element = $ "##{@id}"
    if not @element[0]? #if there is no with app id on dom
      @element = $ "<webview />", {} =
        id : @id
        class : "app"
        src : @src
        plugins: ''
        preload: @getPreload() if @getPreload?
      $('body').prepend @element #add to Dom
    else #check src, class
      @element.attr('preload',@getPreload()) if @getPreload?
      @element.attr('src',@src) if not @element.attr('src')?
      @element.addClass 'app' if not @element.hasClass 'app'
    @element.removeAttr('plugins') if not @withPlugins
    @element.attr('nodeintegration','') if @nodeintegration
    @dom = @element[0]

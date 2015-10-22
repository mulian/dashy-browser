# app-list.coffee
# Hier wird die Applist definiert.
$ = jQuery = require 'jquery'
View = require './view'
App = require './app'
Touch = require './touch'
{settings} = require '../package.json'

module.exports =
class AppList extends View
  list: []
  dom: null

  #### Initial Funktionen

  constructor: ->
    super
    window.eventbus.on "AppManager","changeApp", (app) =>
      @currentApp = app

  #Wird erst nach dem Dom geladen ist ausgefuehrt.
  initialize: ->
    @initDom()
    touch.on(document.body).fingers.eq(1).call(@touchDown)

  #Erstellt die App-Liste im DOM
  initDom: ->
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

  #Initalisiert die Navigationsbutton
  initNavigation: ->
    @navigation = $ '<div />', {} =
      id: 'appListNavigation'
    @back = $ '<button />', {} =
      text: 'Zurück'
    @forward = $ '<button />', {} =
      text: 'Vor'
    @back.click =>
      @currentApp.dom.goBack()
    @forward.click =>
      @currentApp.dom.goForward()
    @navigation.append @back
    @navigation.append @forward
    @dom.append @navigation

  #Initialisiert den Ende Button, der zur Zeit ausgeblendet wird durch css
  initEndButton: ->
    @endButton = $ '<button />', {} =
      text: 'Beenden'
      id: 'end'
    @endButton.click ->
      window.close() #TODO: Nur die Seite ist geschlossen?
    @dom.append @endButton

  #Setzt die Main App
  setMainApp: (@mainApp)->

  #### TOUCH Functionen

  #Wird ausgefuehrt, wenn 3 Finger gedrueckt wurden
  touchDown: (e) =>
    e.preventDefault()
    if e.start
      @setTouchDirection()
    if not e.end or e.start
      @touchFunction e.avg.diff.x
    else
      left = e.lastTouchEvent.avg.diff.x * -1
      @touchFunction e.lastTouchEvent.avg.diff.x, true
  #Feststelle, welche richtung ausgefuehrt wird.
  setTouchDirection: ->
    @domWidth = @dom.width()
    if @dom.is(':visible') #hide
      @touchFunction = @leftToRight
    else
      @dom.show()
      @touchFunction = @rightToLeft
  #Wenn es von links nach recht geht
  leftToRight: (x,end=false) ->
    right = x*-1
    if right<0
      @dom.css 'right', right
    if end
      if (x)>(@domWidth/2)
        @dom.hide()
      else
        @dom.css 'right', 0
  #Wenn es von recht nach links geht
  rightToLeft: (x,end=false) ->
    right = x*-1-@domWidth
    if right<0
      @dom.css 'right', right
    else
      @dom.css 'right', 0

    if end
      if (right*-1)>(@domWidth/2)
        @dom.hide()
      else
        @dom.css 'right', 0

  #### App Listen Funktionen

  #Findet herraus ob die App mit entsprechender URL schon vorhanden und gibt sie ggf. zurueck
  isAppInAppList: (url) ->
    for item in @list
      if item.getSrcId() == url
        return item
    return false

  #Loescht die uebergebene App aus der @list
  remove: (app) ->
    for item, pos in @list
      if app.src == item.src
        app.entry.remove()
        @list.splice pos,1
        return
    console.log "there is no app to close"

  #Initalisiert neue App mit url, falls die URL noch nicht vorhanden ist.
  #Ansonsten wird die vorhanden App angezeigt
  add: (url) ->
    app = @isAppInAppList(url)
    if app==false
      app = new App {src: url}
      @list.push app
      @domList.append app.entry
      # console.log name
    window.eventbus.fire "AppManager","changeApp",app

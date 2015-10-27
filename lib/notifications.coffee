#notifications.coffee
# Gibt die Informationen raus.

View = require './view'
$ = jQuery = require 'jquery'

module.exports =
class Notifications extends View
  que: []
  dom: null
  # Die Zeit in Sekunden, wie lange die Nachricht angezeigt wird.
  time: 6
  nextActive: false

  #### Initial Funktionen

  constructor: ->
    super
    @eventBus = window.eventbus
    @eventBus.on "Notifications", "info", @info
    @eventBus.on "Notifications", "error", @error
    @eventBus.on "Notifications", "setTime", @setTime
    @eventBus.on "Notifications", "getName", @getName

  initialize: ->
    @dom = $('#notifications')
    @input = $('#nInput')
    @text = $('#nText')

    @input.hide()
    @input.keyup (e) =>
      if(e.keyCode == 13)
        @callback @input.val()
        @callback=null
        @input.val('')
        @_prepareNext()
        @input.hide()

  #### Registrierte Funktionen

  # Gibt eine Information aus
  info: (str) =>
    @_addQue "info","#{str}"

  # Gibt einen Error aus
  error: (str) =>
    @_addQue "error","Fehler: #{str}"

  # Hiermit kann die Anzeige-Zeit geaendert werden.
  setTime: (time) ->
    @time = time

  # Fragt nach einen String, und ruft den callback nach eingabe (enter) auf.
  getName: (msg,callback) =>
    @_addQue "getName",msg,callback

  #### Private, Funktionen

  # Verstecke die Nachricht wieder und führe next nach 0,5 sec aus.
  _prepareNext: =>
    @dom.removeAttr "class"
    setTimeout @_next, 500

  # Falls der Dom da ist? Und etwas in der Warteschlange vorhanden ist, zeige dies an.
  _next: =>
    if @dom?
      if @que.length>0
        note = @que.shift()

        @text.text note.msg
        @dom.addClass note.type
        @_nextActive=true

        if note.type=='getName'
          @input.show()
          # setTimeout @input.focus(), 50
          @input.focus()
          @callback = note.callback
        else
          setTimeout @_prepareNext, @time*1000

      else
        @text.text ""
        @_nextActive=false

  # Füge eine Nachricht der Warteschlange hinzu
  _addQue: (type,msg,callback=null) ->
    @que.push {} =
      type: type
      msg: msg
      callback: callback
    @_next() if not @_nextActive

View = require './view'
$ = jQuery = require 'jquery'
module.exports =
class Notifications extends View
  que: []
  dom: null
  time: 4
  nextActive: false

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
        @prepareNext()
        @input.hide()

  getName: (msg,callback) =>
    @addQue "getName",msg,callback

  setTime: (time) ->
    @time = time

  prepareNext: =>
    @dom.removeAttr "class"
    setTimeout @next, 500
  next: =>
    if @dom?
      if @que.length>0
        note = @que.shift()

        @text.text note.msg
        @dom.addClass note.type
        @nextActive=true

        if note.type=='getName'
          @input.show()
          # setTimeout @input.focus(), 50
          @input.focus()
          @callback = note.callback
        else
          setTimeout @prepareNext, @time*1000

      else
        @text.text ""
        @nextActive=false

  addQue: (type,msg,callback=null) ->
    @que.push {} =
      type: type
      msg: msg
      callback: callback
    @next() if not @nextActive

  info: (str) =>
    @addQue "info","#{str}"

  error: (str) =>
    @addQue "error","Fehler: #{str}"

new Notifications()

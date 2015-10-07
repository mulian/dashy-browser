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

  initialize: ->
    @dom = $('#notifications')

  setTime: (time) ->
    @time = time

  next: =>
    if @dom?

      if @que.length>0
        note = @que.pop()
        @dom.text note.msg
        @dom.addClass note.type
        @nextActive=true
        setTimeout =>
          @dom.removeAttr "class"
        , (@time*1000)-500
        setTimeout @next, @time*1000
      else
        @dom.text ""
        @nextActive=false

  addQue: (type,msg) ->
    @que.push {} =
      type: type
      msg: msg
    @next() if not @nextActive

  info: (str) =>
    @addQue "info","#{str}"

  error: (str) =>
    @addQue "error","Error: #{str}"

new Notifications()

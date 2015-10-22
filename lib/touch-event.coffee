# touch-event.coffee
# Erweitert das event object und gibt es an touch.coffee zurück.
$ = jQuery = require 'jquery'
module.exports =
class TouchEvent
  constructor: (@callBack) ->
    $(document).ready @init

  init: =>
    document.body.addEventListener 'touchstart',@touch
    document.body.addEventListener 'touchmove',@touch
    document.body.addEventListener 'touchend',@touch
    document.body.addEventListener 'touchcancel',@touch

  #calculate the x and y average
  average: (touches) ->
    x = 0
    y = 0
    for touch in touches
      x+=touch.clientX
      y+=touch.clientY
    return {} =
      x : x/touches.length
      y : y/touches.length

  startE: null #startEvent
  lastTouchE: null #lst Touch Event
  addDirections: (e) ->
    e.direction = {} =
      left: e.avg.x
      right: window.innerWidth - e.avg.x
      top: e.avg.y
      bottom: window.innerHeight - e.avg.y
  touch: (e) =>
    if e.type != 'touchend'
      if e.type == 'touchstart'
        e.start=true
        @startE = e
      else #touchmove
        e.move=true
      e.avg = @average e.touches
      if @startE?
        e.avg.diff =
          x: e.avg.x - @startE.avg.x
          y: e.avg.y - @startE.avg.y
      @lastTouchE = e
      @addDirections e
    else #touchend
      e.end=true
      e.lastTouchEvent=@lastTouchE


    @startE=null if e.end

    @callBack e

# run = (e) ->
#   console.log "run"

# $(document).ready ->
#   console.log touch.on(document.body).fingers.eq(2).from.left(20).call(run)
  # console.log touch.on(document.body).onStart().fingers.eq(1).onMove().fingers.betweene(1,0).move.X(30).call(run)

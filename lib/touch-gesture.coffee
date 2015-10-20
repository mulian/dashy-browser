# Guesture Side
# fires events on gestures from left and right

# Use Settings from package.json
{settings} = require '../package.json'
Gesture = require './gesture'

module.exports =
class TouchGesture
  constructor: (options) ->
    {@onThreeLeft,@element} = options

    @addEvent 'touchstart',@touchStart
    @addEvent 'touchmove',@touchMove
    @addEvent 'touchend',@touchEnd

  touchStart: (event) ->
    console.log event.touches
    console.log "3Finger" if event.touches.length==3

  addEvent: (name,callBack) ->
    @element.addEventListener name, (e) => @fortifyEvent e,callBack

  fortifyEvent: (event,callFunction) ->
    callFunction event

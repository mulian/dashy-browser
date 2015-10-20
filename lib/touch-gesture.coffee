# Guesture Side
# fires events on gestures from left and right

# Use Settings from package.json
{settings} = require '../package.json'
Gesture = require './gesture'

module.exports =
class TouchGesture
  constructor: (options) ->
    {@onThreeLeft,@element=document.body} = options

    @addEvent 'touchstart',@touchStart
    @addEvent 'touchmove',@touchMove
    @addEvent 'touchend',@touchEnd

  threeActive: false
  touchStart: (e) ->
    console.log e.touches
    @threeActive=on if e.touches.length==3
  touchMove: (e) ->
    console.log "jo" if @threeActive
  touchEnd: (e) ->
    @threeActive=off


  addEvent: (name,callBack) ->
    @element.addEventListener name, (e) => @fortifyEvent e,callBack

  fortifyEvent: (event,callFunction) ->
    callFunction event

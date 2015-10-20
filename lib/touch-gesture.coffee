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
    if e.touches.length==3
      @threeActive=on
      console.log "three touch"

  touchMove: (e) ->
    if @threeActive
      console.log "move"
      console.log e.diff.left
  touchEnd: (e) ->
    @threeActive=off if e.touches.length==2


  addEvent: (name,callBack) ->
    @element.addEventListener name, (e) => @fortifyEvent e,callBack

  startTouches: null
  fortifyEvent: (event,callFunction) ->
    console.log event
    if event.type=='touchstart' and @startTouches==null
      @startTouches = event.touches

    @currentTouch = event.touches[0] if event.touches.lenght>0

    event.left = @currentTouch.clientX
    event.top = @currentTouch.clientY

    event.diff = {} =
      left: event.left-@startTouches[0].clientX
      top: event.top-@startTouches[0].clientY

    if event.type =='touchend' and event.touches.lenght>0
      @startTouches = null

    callFunction event

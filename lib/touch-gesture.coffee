# Guesture Side
# fires events on gestures from left and right

# Use Settings from package.json
{settings} = require '../package.json'
Gesture = require './gesture'

module.exports =
class TouchGesture
  constructor: (options) ->
    {@onThreeTouch,@element=document.body} = options

    @addEvent 'touchstart',@touchStart
    @addEvent 'touchmove',@touchMove
    @addEvent 'touchend',@touchEnd

  threeActive: false
  touchStart: (e) ->
    if e.touches.length==3
      @threeActive=on
      @onThreeTouch e
      # console.log "three touch"

  touchMove: (e) ->
    if @threeActive
      @onThreeTouch e
      # console.log e.diff.left
  touchEnd: (e) ->
    @threeActive=off if e.touches.length==0


  addEvent: (name,callBack) ->
    @element.addEventListener name, (e) => @fortifyEvent e,callBack

  startTouches: null
  fortifyEvent: (event,callFunction) ->
    console.log event
    if event.type=='touchstart' and @startTouches==null
      @startTouches = event.touches
      event.start = true

    @currentTouch = event.touches[0] if event.touches.length>0

    event.left = @currentTouch.clientX
    event.right = @element.offsetWidth-event.left
    event.top = @currentTouch.clientY
    event.bottom = @element.offsetHeight-event.top

    event.diff = {} =
      left: event.left-@startTouches[0].clientX
      right: event.left*-1
      top: event.top-@startTouches[0].clientY
      bottom: event.top*-1

    if event.type =='touchend' and event.touches.lenght>0
      event.end = true
      @startTouches = null

    callFunction event

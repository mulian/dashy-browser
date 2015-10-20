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
  touchStart: (e) =>
    if e.touches.length==3
      @threeActive=on
      @onThreeTouch e
      # console.log "three touch"

  touchMove: (e) =>
    if @threeActive
      @onThreeTouch e
      # console.log e.diff.left
  touchEnd: (e) =>
    @threeActive=off if e.touches.length==0


  addEvent: (name,callBack) ->
    @element.addEventListener name, (e) => @fortifyEvent e,callBack

  startTouches: null
  sum : (touches) ->
    sumX = 0
    sumY = 0
    for touch in touches
      sumX+=touch.clientX
      sumY+=touch.clientY
    return {} =
      sumX : sumX/touches.length
      sumY : sumY/touches.length
  fortifyEvent: (event,callFunction) ->
    if event.type=='touchstart' and @startTouches==null
      @startTouches = @sum event.touches
      event.start = true

    @currentTouch = event.touches if event.touches.length>0
    s = @sum @currentTouch

    event.directions = {} =
      left : s.sumX
      event.right : @element.offsetWidth-event.left
      event.top : s.sumY
      event.bottom : @element.offsetHeight-event.top
    console.log event.directions

    event.diff = {} =
      left: event.left-@startTouches.sumX
      right: event.left*-1
      top: event.top-@startTouches.sumY
      bottom: event.top*-1

    if event.type =='touchend' and event.touches.lenght>0
      event.end = true
      @startTouches = null

    console.log event
    callFunction event

module.exports =
class Guesture
  space: 20
  minActivate: 20
  move :
    left : {}
    right : {}
  on : {}

  #@on.left =  (event) ->
  #@on.right
  #same for right
  constructor: (@on) ->
    @addEventListener()

  addEventListener: ->
    addEventListener = document.body.addEventListener
    addEventListener 'mousedown', (e) => @fortifyEvent e,@mouseDown
    addEventListener 'mousemove', (e) => @fortifyEvent e,@mouseMove
    addEventListener 'mouseup', (e) => @fortifyEvent e,@mouseUp

  fortifyEvent: (event,callFunction) ->
    event.left = event.clientX
    event.winWidth = window.innerWidth
    event.right = event.winWidth-event.left
    event.diffLeft = (event.left-@move.left.start) if @move.left.start?
    event.diffRight = (event.right-@move.right.start) if @move.right.start?
    callFunction event


  mouseDown: (event) =>
    if event.left <= @space and @on.left?
      @move.left.start = event.left
    else if event.right <= @space and @on.right?
      @move.right.start = event.right
  mouseMove: (event) =>
    # console.log @
    @move.left.activate = true if event.diffLeft >= @minActivate
    @move.right.activate = true if event.diffRight >= @minActivate
    if @on.left? and @move.left.activate?
      @on.left event
    else if @on.left? and @move.right.activate?
      @on.right event
  mouseUp: (event) =>
    event.end = true
    if @move.left.activate
      @on.left event
      @stopMove 'left'
    if @move.right.activate
      @on.right event
      @stopMove 'right'

  stopMove: (name) ->
    @move[name] = {}

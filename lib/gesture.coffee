{settings} = require '../package.json'
module.exports =
class Guesture
  space: 20
  minActivate: 40
  move :
    left : {}
    right : {}
  on : {}

  #@on.left =  (event) ->
  #@on.right
  #same for right
  constructor: (options) ->
    {@on,@space,@minActivate} = options
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
    event.diff = {} =
      left : if @move.left.start? then (event.left-@move.left.start) else undefined
      right : if @move.right.start? then (event.right-@move.right.start) else undefined
    callFunction event

  mouseDown: (e) =>
    @checkDown 'left', e
    @checkDown 'right', e
    # if event.left <= @space and @on.left?
    #   @move.left.start = event.left
    # else if event.right <= @space and @on.right?
    #   @move.right.start = event.right
  checkDown: (direction,event) ->
    if event[direction] <= @space and @on[direction]?
      @move[direction].start = event[direction]
  mouseMove: (e) =>
    @checkMove 'left', e
    @checkMove 'right', e
    # @move.left.activate = true if event.diff.left >= @minActivate
    # @move.right.activate = true if event.diff.right >= @minActivate
    # if @on.left? and @move.left.activate?
    #   @on.left event
    # else if @on.left? and @move.right.activate?
    #   @on.right event
  checkMove: (direction,event) ->
    @move[direction].activate = true if event.diff[direction] >= @minActivate
    if @on[direction]? and @move[direction].activate?
      @on[direction] event
  mouseUp: (e) =>
    e.end = true
    @checkUp 'left', e
    @checkUp 'right', e
    # if @move.left.activate
    #   @on.left event
    #   @stopMove 'left'
    # if @move.right.activate
    #   @on.right event
    #   @stopMove 'right'
  checkUp: (direction,event) ->
    if @move[direction].activate
      @on[direction] event
      @move[direction] = {}

  stopMove: (name) ->
    @move[name] = {}

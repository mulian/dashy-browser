# Guesture
# fires events on gestures from left and right

# Use Settings from package.json
{settings} = require '../package.json'

module.exports =
class Guesture
  space: 20
  minActivate: 40
  move :
    left : {}
    right : {}
  on : {}


  #### Construction and other initialize Methode

  #Public: define the options
  # * `options` {Object}
  #   * `space` {Number} check space betweene side and mouseDown
  #   * `minActivate` {Number} the move Pixel's before call the on function
  #   * `on` {Object}
  #     * `left` {Function}
  #       * `event` {Object} the transmitted event
  #     * `right` {Function}
  #       * `event` {Object} the transmitted event
  constructor: (options) ->
    {@on,@space,@minActivate} = options
    @addEventListener()

  #Private: register the Mouse Events to MainPage (Electron)
  addEventListener: ->
    addEventListener = document.body.addEventListener
    addEventListener 'mousedown', (e) => @fortifyEvent e,@mouseDown
    addEventListener 'mousemove', (e) => @fortifyEvent e,@mouseMove
    addEventListener 'mouseup', (e) => @fortifyEvent e,@mouseUp

  #### Event Functions

  #Public: On Mouse press down, check if on left/right side.
  # * `e` {Object} the Event from MainPage (electron)
  mouseDown: (e) =>
    @checkDown 'left', e
    @checkDown 'right', e
  #Private: summery of mouseDown check for every directions
  # * `direction` {String} the direction left/right
  # * `event` {Object} the transmitted event
  checkDown: (direction,event) ->
    if event[direction] <= @space and @on[direction]?
      @move[direction].start = event[direction]

  #Public: On Mouse move, check it was pressed and apply @on[direction] function
  # * `event` {Object} the transmitted event
  mouseMove: (e) =>
    @checkMove 'left', e
    @checkMove 'right', e
  #Private: summery of mouseMove check for every directions
  # * `direction` {String} the direction left/right
  # * `event` {Object} the transmitted event
  checkMove: (direction,event) ->
    @move[direction].activate = true if event.diff[direction] >= @minActivate or event.diff[direction] <= -parseInt(@minActivate)
    if @on[direction]? and @move[direction].activate?
      @on[direction] event

  #Public: On Mouse Up, send last event with event.end=true and uncheck left/right side press.
  # * `event` {Object} the transmitted event
  mouseUp: (e) =>
    e.end = true
    @checkUp 'left', e
    @checkUp 'right', e
  #Private: summery of mouseUp check for every directions
  # * `direction` {String} the direction left/right
  # * `event` {Object} the transmitted event
  checkUp: (direction,event) ->
    if @move[direction].activate
      @on[direction] event
      @move[direction] = {}

  #### Private

  #Private: fortify the event, before call the Event Functions
  # * `event` {Object} transmitted event
  # * `callFunction` {Function} Executeted function after fortify the event Object
  #   * `event` {Object} the fortifyed transmitted event Object
  fortifyEvent: (event,callFunction) ->
    #X Axis
    event.left = event.clientX
    event.winWidth = window.innerWidth
    event.right = event.winWidth-event.left
    #Y Axis
    event.top = event.clientY
    event.winHeight = window.innerHeight
    event.bottom = event.innerHeight-event.top

    addDiff = (direction) ->
      event.diff[direction] = if @move[direction]start? then (event[direction]-@move[direction]start) else undefined
    addDiff 'left'
    addDiff 'right'
    addDiff 'top'
    addDiff 'bottom'
    # event.diff = {} =
    #   left : if @move.left.start? then (event.left-@move.left.start) else undefined
    #   right : if @move.right.start? then (event.right-@move.right.start) else undefined
    #   top: if @move.top.start? then (event.top-@move.top.start) else undefined
    #   top: if @move.top.start? then (event.top-@move.top.start) else undefined
    callFunction event

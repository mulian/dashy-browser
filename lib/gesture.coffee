# Guesture

# Use Settings from package.json
{settings} = require '../package.json'

module.exports =
class Guesture
  move :
    left : {}
    right : {}

  start: null


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
    {@minActivate,@element} = options
    @addEventListener()

  #Private: register the Mouse Events to MainPage (Electron)
  addEventListener: (element=@element)->
    @addEvent element, 'mousedown', @mouseDown
    @addEvent element, 'mousemove', @mouseMove
    @addEvent element, 'mouseup', @mouseUp

  #
  # Add event (name) to element, with callback
  # * element {HTMLElement}:
  # * name {String}: the event Name
  # * callback {Function}: the called Function
  addEvent: (element,name,callBack) ->
    element.addEventListener name, (e) => @fortifyEvent e,callBack

  #### Event Functions

  mouseDown: (event) -> #override me
  mouseMove: (event) -> #override me
  mouseUp: (event) -> #override me

  #### Private

  #Private: fortify the event, before call the Event Functions
  # * `event` {Object} transmitted event
  # * `callFunction` {Function} Executeted function after fortify the event Object
  #   * `event` {Object} the fortifyed transmitted event Object
  fortifyEvent: (event,callFunction) ->
    #window size
    event.win = {} =
      width: window.innerWidth
      height: window.innerHeight
    #Start
    if event.type == 'mousedown'
      @start = {} =
        left: event.clientX
        right: event.win.width-event.clientX
        top: event.clientY
        bottom: event.win.height-event.clientY

    #X Axis
    event.left = event.clientX
    event.right = event.win.width-event.left
    #Y Axis
    event.top = event.clientY
    event.bottom = event.win.height-event.top

    if @start?
      event.start = @start
      #Diff from start
      event.diff = {} =
        left: (event.left-event.start.left)
        right: (event.right-event.start.right)
        top: (event.top-event.start.top)
        bottom: (event.bottom-event.start.bottom)

    if event.type == 'mouseup'
      event.end = true
      @start = null
    # console.log event

    callFunction event

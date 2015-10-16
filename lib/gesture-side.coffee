# Guesture Side
# fires events on gestures from left and right

# Use Settings from package.json
{settings} = require '../package.json'
Gesture = require './gesture'

module.exports =
class GuestureSide extends Gesture
  constructor: (options) ->
    super options
    @addEventListener()

  #Private: register the Mouse Events to MainPage (Electron)
  addEventListener: ->
    addEventListener = document.body.addEventListener
    addEventListener 'mousedown', (e) => @fortifyEvent e,@mouseDown
    addEventListener 'mousemove', (e) => @fortifyEvent e,@mouseMove
    addEventListener 'mouseup', (e) => @fortifyEvent e,@mouseUp

  #Public: On Mouse press down, check if on left/right side.
  # * `e` {Object} the Event from MainPage (electron)
  mouseDown: (e) =>
    @checkDown 'left', e
    @checkDown 'right', e

  #Public: On Mouse move, check it was pressed and apply @on[direction] function
  # * `event` {Object} the transmitted event
  mouseMove: (e) =>
    @checkMove 'left', e
    @checkMove 'right', e

  #Public: On Mouse Up, send last event with event.end=true and uncheck left/right side press.
  # * `event` {Object} the transmitted event
  mouseUp: (e) =>
    e.end = true
    @checkUp 'left', e
    @checkUp 'right', e

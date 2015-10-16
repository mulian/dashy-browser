# Guesture
# fires events on gestures from left and right

# Use Settings from package.json
{settings} = require '../package.json'
Gesture = require './gesture'

module.exports =
class GuestureItem extends Gesture
  active: false
  constructor: (options) ->
    {@moveX} = options
    super options


  #Override: On Mouse move, check it was pressed and apply @on[direction] function
  # * `event` {Object} the transmitted event
  mouseMove: (e) =>
    if e.start? and e.diff.left>=10
      @active=true
      @moveX e
      # console.log "jo"
      # console.log e


  #Public: On Mouse Up, send last event with event.end=true and uncheck left/right side press.
  # * `event` {Object} the transmitted event
  mouseUp: (e) =>
    if @active
      @moveX e
      @active=false

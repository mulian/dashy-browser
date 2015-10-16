# Guesture Side
# fires events on gestures from left and right

# Use Settings from package.json
{settings} = require '../package.json'
Gesture = require './gesture'

module.exports =
class GuestureSide extends Gesture
  space: 20
  minActivate: 40
  on : {}
  active:
    left: {}
    right: {}

  constructor: (options) ->
    {@on,@space,@minActivate} = options
    options.element = document.body
    super options

  mouseDown: (e) =>
    if e.left<=@space
      @active.left.down = true
    if e.right<=@space
      @active.right.down = true

  #Override: On Mouse move, check it was pressed and apply @on[direction] function
  # * `event` {Object} the transmitted event
  mouseMove: (e) =>
    if @active.left.down
      if not @active.left.active? and e.diff.left>=@minActivate
        @active.left.active=true
      if @active.left.active
        @on.left e
    if @active.right.down
      if not @active.right.active? and e.diff.right>=@minActivate
        @active.right.active=true
      if @active.right.active
        @on.right e


  #Public: On Mouse Up, send last event with event.end=true and uncheck left/right side press.
  # * `event` {Object} the transmitted event
  mouseUp: (e) =>
    @on.left e if @active.left.active
    @on.right e if @active.right.active
    @active = {} =
      left: {}
      right: {}

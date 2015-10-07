View = require './view'
$ = jQuery = require 'jquery'
module.exports =
class ShowTouch extends View
  gfx: null
  constructor: () ->
    super
    window.eventbus.on "ShowTouch","left",@showLeft
    window.eventbus.on "ShowTouch","right",@showRight

  initialize: ->
    @gfx = $('#touch') if not @gfx?
    @label = $('#touch_label') if not @label?

  # Show left
  # * options {Object}
  #   * afterThis {Function} Fires after this show event
  #   * time {Number} secunds to hide
  show: (side,info,{after=undefined,time=4}={}) =>
    @gfx.addClass side
    window.eventbus.fire 'Notifications','info', info
    # @label.text "Return to Dashboard" #later use Notification Center
    setTimeout =>
      @gfx.removeClass side
      after() if after?
    , time*1000
  # Use Options from show
  showLeft: (options) =>
    @show "left",'Touch left side to right to return to Dashboard', options
  # Use Options from show
  showRight: (options) =>
    @show 'right','Touch right side to left to show open apps', options

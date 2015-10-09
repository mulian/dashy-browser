View = require './view'
$ = jQuery = require 'jquery'
{settings} = require '../package.json'
module.exports =
class ShowTouch extends View
  gfx: null
  modules: {}
  constructor: () ->
    super
    window.eventbus.on "ShowTouch","left",@showLeft
    window.eventbus.on "ShowTouch","right",@showRight

  initialize: ->
    @gfx = $('#touch') if not @gfx?
    @label = $('#touch_label') if not @label?
    @modules['left'] = $('#app_daisy')
    @modules['right'] = $('#app_liste')

  # Show left
  # * options {Object}
  #   * afterThis {Function} Fires after this show event
  #   * time {Number} secunds to hide
  show: (side,info,{after=undefined,time=4}={}) =>
    if settings?.showIntroduction != false
      @gfx.addClass side
      @modules[side].addClass 'flyin'
      # window.eventbus.fire 'Notifications','info', info
      # @label.text "Return to Dashboard" #later use Notification Center
      setTimeout =>
        @modules[side].removeClass 'flyin'
        @gfx.removeClass side
        after() if after?
      , time*1000
  # Use Options from show
  showLeft: (options) =>
    @show "left",'[Aktion] Von ganz links nach recht: Dashboard', options
  # Use Options from show
  showRight: (options) =>
    @show 'right','[Aktion] Von ganz rechts nach links: Tab-Menu', options

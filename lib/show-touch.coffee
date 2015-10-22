#show-touch.coffee
# Show Touch Tutorial

$ = jQuery = require 'jquery'
View = require './view'
{settings} = require '../package.json'

module.exports =
class ShowTouch extends View
  gfx: null
  modules: {}

  #### Initiat Functions

  constructor: () ->
    super
    window.eventbus.on "ShowTouch","menu",@showMenu

  initialize: ->
    @gfx = $('#touch') if not @gfx?
    @menu = $('#app_liste')

  #### Show Functions

  # Show left
  # * options {Object}
  #   * afterThis {Function} Fires after this show event
  #   * time {Number} secunds to hide
  show: (side,info,{after=undefined,time=4}={}) =>
    if settings?.showIntroduction != false
      @gfx.addClass side
      @menu.addClass 'flyin'
      # window.eventbus.fire 'Notifications','info', info
      # @label.text "Return to Dashboard" #later use Notification Center
      setTimeout =>
        @menu.removeClass 'flyin'
        @gfx.removeClass side
        after() if after?
      , time*1000
  # Use Options from show
  showMenu: (options) =>
    @show "menu",'[Aktion] Von ganz links nach recht: Dashboard', options

#Included from Electron->index.html
$ = jQuery = require 'jquery'
bla = require './src/test'
fs = require 'fs'
{settings} = require './package.json'

Gesture = require './src/gesture'
AppManager = require './src/app-manager'
View = require './src/view'

#Eventbus will be added on window.eventbus
EventBus = require './src/event-bus'
#Notifications will registrate events
Notifications = require './src/notifications'

# Client wie be included from ../index.html
# It initiate the DOM, ....
class Client extends View
  # Public: Registrate the Electron events with jQuery
  constructor: ->
    super
    @appManager = new AppManager()
  # Private: Starts with document ready
  # initialize: ->
  #   @defineVars()
  #   @resize() #resize on start up

  # Private: Define The Variables
  # defineVars: ->
  #   @body = $ 'body'

    # @gesture = new Gesture
    #   space: settings.guesture.space
    #   minActivate: settings.guesture.minActivate
    #   on:
    #     left: @onLeft
        # onRight: left

  # onLeft : (e) =>
  #   e.preventDefault()
  #   # console.log "LEFT: #{e.clientX}"
  #   console.log "#{e.diff.left-e.winWidth}px"
  #   @daisy.element.css 'left', "#{e.diff.left-e.winWidth}px"
  #   if e.end
  #     console.log "ENDE"

  # Private: fires on every resize Event from electron
  resize: ->
    @body = $('body') if not @body?
    console.log @body
    @body.width $(window).width()
    @body.height $(window).height()
new Client()

#Included from Electron->index.html
$ = jQuery = require 'jquery'
bla = require './src/test'
fs = require 'fs'
{settings} = require './package.json'

Gesture = require './src/gesture'
MainApp = require './src/main-app'

favicon = require('favicon');

favicon "https://marvelapp.com", (err, favicon_url) ->
  console.log favicon_url

class Client
  constructor: ->
    $(document).ready @initialize
    $(window).resize @resize
  initialize: =>
    @defineVars()
    @resize() #resize on start up

  defineVars: ->
    @body = $ 'body'
    @daisy = new MainApp
      id: '#daisy'
    @gesture = new Gesture
      left: @onLeft
      # onRight: left

  onLeft : (e) =>
    e.preventDefault()
    # console.log "LEFT: #{e.clientX}"
    daisy.css 'left', "#{e.left}px"
    if e.end
      console.log "ENDE"

  resize: =>
    @body.width $(window).width()
    @body.height $(window).height()
new Client()

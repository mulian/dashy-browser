View = require './view'
$ = jQuery = require 'jquery'

module.exports =
class Save
  constructor: ->
    window.eventbus.on "App","afterPageLoad", @check

  save: (options) ->
    window.eventbus.fire 'MainApp','uploadFile', options

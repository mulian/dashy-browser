# Prowise
Save = require './save'

module.exports =
class ProwisePlugin extends Save
  url: /https:\/\/prowise\.com\/presenter\/start/

  #Will call if after every page load
  check: (app) =>
    appUrl = app.dom.getUrl()
    if @url.test appUrl
      @info()

  #Present Info
  info: ->
    setTimeout ->
      eventbus.fire "Notifications",'info', "Bitte drücken Sie auf Abbrechen."
    , 2*1000

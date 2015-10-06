$ = jQuery = require 'jquery'
{settings} = require '../package.json'

module.exports =
class Daisy
  constructor: (@id='#daisy') ->
    @element = $ @id
    @domElement = @element[0]
    @element.attr 'src',settings.url
    @initEvent()

  initEvent: ->
    @domElement.addEventListener 'new-window', (e) ->
      console.log "new Window"
      console.log e
    @domElement.addEventListener 'console-message', (e) ->
      console.log('daisy: ', e.message)
    @domElement.addEventListener 'did-frame-finish-load', (event, isMainFrame) ->
      # @domElement.executeJavaScript "daisyOnlyShowMenuScript = #{daisyOnlyShowMenuScript.toString()}"
      console.log "finished loading"

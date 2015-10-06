$ = jQuery = require 'jquery'
{settings} = require '../package.json'

module.exports =
class MainApp
  constructor: (options={}) ->
    {@id='#daisy',@newWindow=@newWindow} = options
    @initElements()
    @initEvent()

  initElements: ->
    @element = $ @id
    @element.attr 'src',settings.url
    @dom = @element[0]
  initEvent: ->
    @dom.addEventListener 'new-window', @newWindow
    @dom.addEventListener 'console-message', @log
    @dom.addEventListener 'did-frame-finish-load', @finishLoad

  newWindow: (e) ->
    console.log "new Window"
    console.log e
  log: (e) ->
    console.log('daisy: ', e.message)
  finishLoad: (event, isMainFrame) ->
    # @dom.executeJavaScript "daisyOnlyShowMenuScript = #{daisyOnlyShowMenuScript.toString()}"
    console.log "finished loading"

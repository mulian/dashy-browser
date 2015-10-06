$ = jQuery = require 'jquery'
{settings} = require '../package.json'
App = require './app'

# The Main App for AppManager
module.exports =
class MainApp extends App
  # Constructor
  # * `options` {Object}
  #   * `name` {String} the name of app (like id)
  #   * `on' {Object}
  #     * `newWindow` {Function}
  #       * `event` {Object}
  #     * `log` {Function}
  #       * `event` {Object}
  #     * `finishLoad` {Function}
  #       * `event` {Object}
  constructor: (options={}) ->
    {@on} = options
    options.withPlugins = false
    super options
    # @initElements()

  initialize: ->
    super
    @initEvent()


  initEvent: ->
    @dom.addEventListener 'new-window', @on.newWindow if @on.newWindow
    if @on.log
      @dom.addEventListener 'console-message', @on.log
    else @dom.addEventListener 'console-message', @log
    @dom.addEventListener 'did-frame-finish-load', @on.finishLoad if @on.finishLoad

  # newWindow: (e) ->
  #   console.log "new Window"
  #   console.log e
  log: (e) =>
    console.log("#{@name}: #{e.message}")
  # finishLoad: (event, isMainFrame) ->
  #   # @dom.executeJavaScript "daisyOnlyShowMenuScript = #{daisyOnlyShowMenuScript.toString()}"
  #   console.log "finished loading"

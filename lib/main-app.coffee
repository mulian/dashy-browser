$ = jQuery = require 'jquery'
{settings} = require '../package.json'
App = require './app'
fs = require 'fs'

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
    {@on,@name} = options
    options.withPlugins = false
    options.nodeintegration=true
    super options
    # @initElements()
    window.eventbus.on 'MainApp','uploadFile', @uploadFile

  getPreload: ->
    './src/daisy-execute.js'

  initialize: ->
    super
    @initEvent()
    @changeId @name,true


  initEvent: ->
    @dom.addEventListener 'new-window', @on.newWindow if @on.newWindow
    if @on.log
      @dom.addEventListener 'console-message', @on.log
    else @dom.addEventListener 'console-message', @log
    @dom.addEventListener 'did-frame-finish-load', @finishLoad
    @dom.addEventListener 'ipc-message', @ipcMsg

  ipcMsg: (event) =>
    if event.channel == 'uploadReady'
      # console.log event
      window.eventbus.fire "Notifications","info","UPLOAD READY!"

  ipcSend: (channel,args) ->
    @dom.send channel,args

  uploadFile: (options) =>
    {appName,url,data,fileName,type} = options
    @ipcSend 'upload', options

  # newWindow: (e) ->
  #   console.log "new Window"
  #   console.log e
  log: (e) =>
    console.log("#{@name}: #{e.message}")
  finishLoad: (event, isMainFrame) =>
    # @dom.executeJavaScript fs.readFileSync './src/daisy-interface.js','utf8'
    console.log "finished loading"
    # setTimeout =>
    #   console.log "start upload?"
    #   @dom.executeJavaScript "window.di.uploadFile('GeileApp','http://www.geileapp.de','DATA!','dateiname','type');"
    # , 20*1000

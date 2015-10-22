# The View calls initialize,
# on document.ready and direct if document is already ready
# If there is a reisze Methode, it calls on every resize and on first document ready.
$ = jQuery = require 'jquery'
module.exports =
class View

  #### Initial Funktionen

  constructor: ->
    @initResize()
    @initInitialize()
    @test() if @test?

  initResize: ->
    if @resize?
      @callResize=true
      $(window).resize => @resize
  initInitialize: ->
    if @initialize?
      if @isDocumentReady()
        @callInitialize()
      else $(document).ready @callInitialize

  callInitialize: =>
    @initialize()
    if @callResize
      @resize
      @callResize=false

  #check if document is ready
  # Return {Boolean} true if already ready
  isDocumentReady: ->
    document.readyState == 'complete'

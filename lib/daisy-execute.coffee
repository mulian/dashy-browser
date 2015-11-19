# daisy-execute.coffee
# Wird in Daisy 'eingespeisst' und intiialisiert wichtige Klassen.
EventBus = require "./event-bus"
DaisyInterface = require "./daisy-interface"
DaisyIPC = require "./daisy-ipc"
jQuery = require('jquery');

console.log "insert from Dashy"

window.electron = true #set identificatin

console.log document
# $ = jQuery = require('jquery')
#load jquery for web app
# try
window.$ = window.jQuery = jQuery
# catch e
#   console.log e
  # js = document.createElement("script");
  # js.type = "text/javascript";
  # js.src = '/js/jquery.js';
  # document.getElementsByTagName('head')[0].appendChild js
document.addEventListener "DOMContentLoaded", ->
  if document.readyState == "complete"
    document.removeEventListener( "onreadystatechange", arguments.callee )
    # document.body.appendChild js
    window.$ = window.jQuery = jQuery


    console.log "test string"
    #load lib

    #run lib
    window.eventbus = new EventBus()
    daisyInterface = new DaisyInterface()
    daisyIPC = new DaisyIPC()

    daisyInterface.getUserId()

delete window.require

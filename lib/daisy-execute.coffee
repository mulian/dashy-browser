# daisy-execute.coffee
# Wird in Daisy 'eingespeisst' und intiialisiert wichtige Klassen.

window.electron = true #set identificatin

#load jquery for web app
window.$ = window.jQuery = require('jquery');
#load lib
EventBus = require "./event-bus"
DaisyInterface = require "./daisy-interface"
DaisyIPC = require "./daisy-ipc"

#run lib
window.eventbus = new EventBus()
daisyInterface = new DaisyInterface()
daisyIPC = new DaisyIPC()

#will be injected in to daisy
window.electron = true #set identificatin

#load jquery for web app
window.$ = window.jQuery = require('jquery');
#load lib
EventBus = require "./event-bus"
DaisyInterface = require "./daisy-interface"
DaisyIPC = require "./daisy-ipc"

#run lib
daisyInterface = new DaisyInterface()
daisyIPC = new DaisyIPC()

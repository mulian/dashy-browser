#will be injected in to daisy
window.electron = true #set identificatin

EventBus = require "./event-bus"
DaisyInterface = require "./daisy-interface"
DaisyIPC = require "./daisy-ipc"

daisyInterface = new DaisyInterface()
daisyIPC = new DaisyIPC()


# setTimeout ->
#   window.eventbus.fire "DaisyInterface","uploadFile",
#     appName: 'EventBusTestApp'
#     url: 'http://www.geileapp.de'
#     data: 'DATA!'
#     fileName: 'dateiname'
#     type: 'type'
# , 10*1000

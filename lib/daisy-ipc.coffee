# daisy-ipc.coffee
# Wird in der App Daisy ausgefuert.
# Ist die Schnittstelle zu dem Daisy-Browser

module.exports =
class DaisyIPC
  ipc: null
  constructor: ->
    @ipc = require 'ipc'
    @ipc.on 'upload', @upload
    window.eventbus.on "DaisyInterface","uploadFileReady", @uploadReady
    window.eventbus.on "DaisyInterface","sendLogin", @sendLogin

  # Gibt die Datei an das DaisyInterface weiter
  upload: (options) =>
    # {appName,url,data,fileName,type} = options
    window.eventbus.fire "DaisyInterface","uploadFile", options
  #Wenn ein Upload fertig ist.
  uploadReady: (data) =>
    @ipc.sendToHost 'uploadReady', data

  sendLogin: (id) ->
    console.log "User #{id} logged in."
    @ipc.sendToHost 'sendLogin', id

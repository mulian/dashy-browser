module.exports =
class DaisyIPC
  ipc: null
  constructor: ->
    @ipc = require 'ipc'
    @ipc.on 'upload', @upload

    window.eventbus.on "DaisyInterface","uploadFileReady", @uploadReady

  upload: (options) =>
    # {appName,url,data,fileName,type} = options
    window.eventbus.fire "DaisyInterface","uploadFile", options
  uploadReady: (data) =>
    @ipc.sendToHost 'uploadReady', data

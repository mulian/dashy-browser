# daisy-interface.coffe
# Wird in der App Daisy ausgefuert und stellt die Schnittstelle her.
module.exports =
class DaisyInterface
  # registriert die Schnittstelle
  constructor: ->
    # window.eventbus.on "DaisyInterface","uploadFile", @uploadFile
    @getUserId()
  # Fragt Daisy (den Server mit CakePHP) an.
  callDaisy: (url, data_array, cb) ->
    # console.log data_array.data.data.length
    url = '../FileUploads/' + url
    $.ajax(
      url: url
      type: 'POST'
      data: data_array
      dataType: 'json'
      async: true
      cache: false
      ).always cb

  getUserId: =>
    @callDaisy 'get_user_id',{}, (data) ->
      if data.status=='success'
        console.log "user_id:#{data.user_id}"

  #Upload file to Daisy
  # The Data will be saved as filename.type with url from app and appName
  #
  # * obj {Object}
  #   * appName {String}
  #   * url {String}
  #   * data {String}
  #   * fileName {String}
  #   * type {string}
  uploadFile: (options) =>
    @getUserId()
    # {appName,url,data,filename,type} = options
    # upload = {} =
    #   appname: appName
    #   url: url
    #   data:
    #     data: data
    #     name: filename
    #     type: type
    # @callDaisy 'uploadFile',
    # options.upload = upload
    # , (returnObj) =>
    #   options.return = returnObj
    #   options.data = 'deletet from daisy'
    #   window.eventbus.fire "DaisyInterface","uploadFileReady", options
      # console.log JSON.stringify returnObj

console.log "inserted"
document.addEventListener "DOMContentLoaded", ->
  # console.log "run, #{document.readyState}"
  # if document.readyState == "complete"
  document.removeEventListener( "onreadystatechange", arguments.callee )
  daisyInterface = new DaisyInterface()

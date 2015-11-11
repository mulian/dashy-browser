# daisy-interface.coffe
# Wird in der App Daisy ausgefuert und stellt die Schnittstelle her.
module.exports =
class DaisyInterface
  # registriert die Schnittstelle
  constructor: ->
    window.eventbus.on "DaisyInterface","uploadFile", @uploadFile

  # Fragt Daisy (den Server mit CakePHP) an.
  callDaisy: (url, data_array, cb) ->
    # console.log data_array.data.data.length
    url = '../FileUploads/' + url
    $.ajax(
      'url': url
      'type': 'POST'
      'data': data_array
      'dataType': 'json'
      'async': true
      'cache': false).always cb

  getUserId: =>
    console.log "und?"
    @callDaisy 'get_user_id',{}, (data,data2) ->
      console.log "get_user_id"
      console.log data
      console.log data2

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

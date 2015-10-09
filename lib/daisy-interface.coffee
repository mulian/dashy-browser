#Schnittstelle.getUserProjectCalendar user_id, showCalendar
module.exports =
class DaisyInterface
  constructor: ->
    window.eventbus.on "DaisyInterface","uploadFile", @uploadFile
  callDaisy: (url, data_array, cb) ->
    #DEBUG  ((a < b) ? 2 : 3);
    # console.log 'DEBUG: DaisyInterface.callDaisy(url=' + url + ',data_array=' + JSON.stringify(data_array) + ',cb=' + (if cb == undefined then 'nicht vorhanden' else 'vorhanden') + ');'
    console.log data_array.data.data.length
    url = '../FileUploads/' + url
    $.ajax(
      'url': url
      'type': 'POST'
      'data': data_array
      'dataType': 'json'
      'async': true
      'cache': false).always cb

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
    {appName,url,data,fileName,type} = options
    @callDaisy 'uploadFile', {} =
      appname: appName
      url: url
      data:
        data: data
        name: fileName
        type: type
    , (returnObj) ->
      options.return = returnObj
      options.data = 'deletet from daisy'
      window.eventbus.fire "DaisyInterface","uploadFileReady", options
      # console.log JSON.stringify returnObj

# console.log "interface!"

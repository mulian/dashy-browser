#Schnittstelle.getUserProjectCalendar user_id, showCalendar
class DaisyInterface
  callDaisy: (url, data_array, cb) ->
    #DEBUG  ((a < b) ? 2 : 3);
    console.log 'DEBUG: DaisyInterface.callDaisy(url=' + url + ',data_array=' + JSON.stringify(data_array) + ',cb=' + (if cb == undefined then 'nicht vorhanden' else 'vorhanden') + ');'
    #url = "http://pes.max-n.de/Calendars/"+url;
    url = '../FileUploads/' + url
    $.ajax(
      'url': url
      'type': 'POST'
      'data': data_array
      'dataType': 'json'
      'async': true
      'cache': false).always cb

  uploadFile: (appName,url,data,fileName,type) ->
    # uploadFile($appname = null, $url = null, $data = null)
    @callDaisy 'uploadFile', {} =
      appname: appName
      url: url
      data:
        data: data
        name: fileName
        type: type
    , (returnObj) ->
      console.log "return"
      console.log returnObj
window.di = new DaisyInterface()

#Schnittstelle.getUserProjectCalendar user_id, showCalendar
DaisyInterface =
  callDaisy: (url, data_array, cb) ->
    #DEBUG  ((a < b) ? 2 : 3);
    console.log 'DEBUG: Schnittstelle.callDaisy(url=' + url + ',data_array=' + JSON.stringify(data_array) + ',cb=' + (if cb == undefined then 'nicht vorhanden' else 'vorhanden') + ');'
    #url = "http://pes.max-n.de/Calendars/"+url;
    url = '../FileUploadsController/' + url
    $.ajax(
      'url': url
      'type': 'POST'
      'data': data_array
      'dataType': 'json'
      'async': true
      'cache': false).always cb

  test: "JAJJSAJSJDASD"

  uploadFile: (appName,url,data) ->
    uploadFile($appname = null, $url = null, $data = null)
    @callDaisy 'uploadFile', {} =
      appname: appName
      url: url
      data: data
    , (returnObj) ->
      console.log returnObj
console.log DaisyInterface.test

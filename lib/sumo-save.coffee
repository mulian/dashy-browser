View = require './view'
$ = jQuery = require 'jquery'
Save = require './save'

module.exports =
class SumoSave extends Save
  saveStartUrlRE: /https?:\/\/www\.sumopaint\.com\/act\/saved\.php/
  sumoUrlRE: /https?:\/\/www\.sumopaint\.com/
  saveUrlRE: /https?:\/\/www\.sumopaint\.com\/paint\/\?url=https?:\/\/www\.sumopaint\.com\/images\/temp\/([\w]*)\.png&target=\/act\/saved\.php/

  #Will call if after every page load
  check: (app) =>
    appUrl = app.dom.getUrl()
    if @saveStartUrlRE.test appUrl
      @insertSaveAction app
    else if @saveUrlRE.test appUrl
      @saveUrl = appUrl
      eventbus.fire 'Notifications','getName','Dateiname:',@saveFile

    else if @sumoUrlRE.test app.dom.getUrl()
      @onSumoStart app
  saveFile: (name) =>
    @save
      appName: 'sumo'
      url: @saveUrl
      data: ''
      fileName: name
      type: 'url'
  insertSaveAction: (app) ->
    # console.log "var run = #{@getCode.toString()}; run()"
    app.dom.executeJavaScript "var run = #{@getCode.toString()}; run()"
  onSumoStart: (app) ->
    app.dom.executeJavaScript "sumopaint();"
    window.eventbus.fire "Notifications",'info', "Um zu speichern auf: 'File > Save to Cloud' tippen."

  #Will be inserted on save
  #It search the editor URL and redirect to it, to get the URL on next afterPageLoad
  #advantage: get the Save URL without nodeintegration
  getCode: ->
    urlRE=/https?:\/\/www\.sumopaint\.com\/paint\/\?url=https?:\/\/www\.sumopaint\.com\/images\/temp\/[\w]*\.png&target=\/act\/saved\.php/
    as = document.getElementsByTagName('a');
    for a in as
      if urlRE.test a.href
        window.location.href=a.href
        console.log "success!"
    console.log "error!"

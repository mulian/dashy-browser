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
    if @saveStartUrlRE.test app.dom.getUrl()
      @insertSaveAction app
    else if @saveUrlRE.test app.dom.getUrl()
      name = @saveUrlRE.exec url
      @save
        appName: 'sumo'
        url: app.dom.getUrl()
        data: ''
        fileName: "Sumo_#{name[1]}"
        type: 'url'

    else if @sumoUrlRE.test app.dom.getUrl()
      @onSumoStart app
  insertSaveAction: (app) ->
    console.log "var run = #{@getCode.toString()}; run()"
    app.dom.executeJavaScript "var run = #{@getCode.toString()}; run()"
  onSumoStart: (app) ->
    app.dom.executeJavaScript "sumopaint();"
    window.eventbus.fire "Notifications",'info', "Zum speichern auf File > Save to Cloud clicken."

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

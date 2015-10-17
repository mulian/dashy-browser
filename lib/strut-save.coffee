View = require './view'
$ = jQuery = require 'jquery'
Save = require './save'

module.exports =
class StrutSave extends Save
  urlRE: /\/daisy-strut\//
  check: (app) =>
    if @urlRE.test app.dom.getUrl()
      app.element.attr 'nodeintegration',''
      app.dom.executeJavaScript "$('#modals').append($('<div>asd</div>'));"
      console.log "strut"

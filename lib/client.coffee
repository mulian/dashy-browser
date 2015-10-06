#Included from Electron->index.html
$ = jQuery = require 'jquery'
bla = require './src/test'
fs = require 'fs'
{settings} = require './package.json'

Gesture = require './src/gesture'
Daisy = require './src/daisy'

favicon = require('favicon');

favicon "https://marvelapp.com", (err, favicon_url) ->
  console.log favicon_url

menu=null
body=null
daisy=null
sidebar=null

class Client
  constructor: ->
    $(document).ready @initialize
    $(window).resize @resize
  initialize: =>
    @defineVars()

    @resize()

  defineVars: ->
    @body = $ 'body'
    @daisy = new Daisy()
    @gesture = new Gesture
      left: @onLeft
      # onRight: left


  onLeft : (e) =>
    e.preventDefault()
    # console.log "LEFT: #{e.clientX}"
    daisy.css 'left', "#{e.left}px"
    if e.end
      console.log "ENDE"

  resize: =>
    @body.width $(window).width()
    @body.height $(window).height()
new Client()
#TODO: after onLeft
# resize = ->
#   body?=$ 'body'
#   body.width $(window).width()
# #   body.height $(window).height()
#
# # $(window).resize (event) ->
#   # resize()
#
# # $(document).ready ->
# asd = ->
#   # daisy = $('#daisy')
#   # onLeft = (e) ->
#   #   e.preventDefault()
#   #   # console.log "LEFT: #{e.clientX}"
#   #   daisy.css 'left', "#{e.clientX}px"
#   #   if e.end
#   #     console.log "ENDE"
#   # gesture = new Gesture
#   #   left: onLeft
#   #   # onRight: left
#   #
#   # resize()
#   # console.log "Client test"
#   #
#   #
#   # daisy.attr 'src',settings.url
#   dai = document.getElementById 'daisy'
#   console.log dai
#   body= $('body')
#   # menu = require('./src/menu') $,daisy
#   # console.log dai.send
#
#
#   menujs = fs.readFileSync './src/menu.js','utf8'
#   # console.log menujs.toString()
#
#   dai.addEventListener 'did-get-response-details', (status,newUrl,originalUrl,httpResponseCode,requestMethod,referrer,headers) ->
#     # console.log "dai: #{newUrl}"
#
#   dai.addEventListener 'new-window', (e) ->
#     console.log "new Window"
#     console.log e
#
#   dai.addEventListener 'console-message', (e) ->
#     console.log('daisy:', e.message)
#
#   dai.addEventListener 'did-frame-finish-load', (event, isMainFrame) ->
#     dai.executeJavaScript "daisyOnlyShowMenuScript = #{daisyOnlyShowMenuScript.toString()}"
#     console.log "finished loading"
#     # showMenu true
#     # dai.executeJavaScript menujs.toString()
#   dai.addEventListener 'ipc-message', (event) ->
#     # console.log event
#     if event.channel == 'sidebar'
#       re = /(<script>([\w\s#\(\)'.\{\},;]+)<\/script>)/
#       str = event.args[0]
#       script = re.exec str
#       str = str.replace re, ''
#       console.log script
#       eval script[2]
#       console.log str
#       sidebar = $ str #<script>(\w+)<\/script>
#       sidebar.css "position", "absolut"
#       body.append sidebar
#     else if event.channel == 'console'
#       console.log "IPC: #{event.args[0]}"
#   # console.log 'did-frame-finish-load: ' + isMainFrame
#
#   sumo = $('<webview />', {src: 'https://www.sumopaint.com/home/#app',autosize:'on', 'plugins'} )
#   # sumo = document.createElement "webview"
#   # sumo.src = 'https://www.sumopaint.com/home/#app'
#
#   firefox = $('<webview />', {src: 'https://www.mozilla.org/en-US/firefox/new/#download-fx',autosize:'on'})
  # firefox = document.createElement "webview"
  # firefox.src = 'https://www.mozilla.org/en-US/firefox/new/#download-fx'

  # console.log firefox
  # $('body').append firefox
  # console.log body
  # setTimeout ->
  #   daisy.hide()
  #   body.append sumo
  # , 2000

  # showMenu = (show) ->
  #   if show
  #     dai.executeJavaScript "daisyOnlyShowMenuScript(true);"
  #     dai.classList.add 'menu'
  #   else
  #     dai.executeJavaScript "daisyOnlyShowMenuScript(false);"
  #     dai.classList.remove 'menu'
  #
  # daisyOnlyShowMenuScript = (onlyShow=true) ->
  #   header = document.getElementsByTagName 'header'
  #   content = document.getElementById 'main-content'
  #   show = ->
  #     header[0].classList.add 'hide'
  #     content.classList.add 'hide'
  #   hide = ->
  #     header[0].classList.remove 'hide'
  #     content.classList.remove 'hide'
  #   if onlyShow
  #     show()
  #   else hide()
  # console.log "daisyOnlyShowMenuScript = #{daisyOnlyShowMenuScript.toString()}"

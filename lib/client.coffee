$ = jQuery = require 'jquery'
bla = require './src/test'
fs = require 'fs'

menu=null
body=null
daisy=null
sidebar=null
resize = ->
  body?=$('body')
  body.width $(window).width()
  body.height $(window).height()

$(window).resize (event) ->
  resize()

$(document).ready ->
  resize()
  console.log "Client test"

  daisy = $('#daisy')
  dai = document.getElementById 'daisy'
  console.log dai
  body= $('body')
  # menu = require('./src/menu') $,daisy
  # console.log dai.send


  menujs = fs.readFileSync './src/menu.js','utf8'
  # console.log menujs.toString()
  dai.addEventListener 'did-frame-finish-load', (event, isMainFrame) ->
    dai.addEventListener 'console-message', (e) ->
      console.log('daisy:', e.message)
    dai.addEventListener 'ipc-message', (event) ->
      # console.log event
      if event.channel == 'sidebar'
        re = /(<script>([\w\s#\(\)'.\{\},;]+)<\/script>)/
        str = event.args[0]
        script = re.exec str
        str = str.replace re, ''
        console.log script
        eval script[2]
        console.log str
        sidebar = $ str #<script>(\w+)<\/script>
        sidebar.css "position", "absolut"
        body.append sidebar
      else if event.channel == 'console'
        console.log "IPC: #{event.args[0]}"
    # console.log 'did-frame-finish-load: ' + isMainFrame
    # console.log menujs.toString()
    dai.executeJavaScript menujs.toString()
    # dai.send('get-sidebar')

  sumo = $('<webview />', {src: 'https://www.sumopaint.com/home/#app',autosize:'on', 'plugins'} )
  # sumo = document.createElement "webview"
  # sumo.src = 'https://www.sumopaint.com/home/#app'

  firefox = $('<webview />', {src: 'https://www.mozilla.org/en-US/firefox/new/#download-fx',autosize:'on'})
  # firefox = document.createElement "webview"
  # firefox.src = 'https://www.mozilla.org/en-US/firefox/new/#download-fx'

  # console.log firefox
  # $('body').append firefox
  # console.log body
  # setTimeout ->
  #   daisy.hide()
  #   body.append sumo
  # , 2000

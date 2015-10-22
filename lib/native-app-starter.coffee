#native-app-starter.coffee
# Startet die Nativ Apps

{settings} = require '../package.json'
{exec} = require 'child_process'

module.exports =
class NativeAppStarter
  nativeRE: /^([\w]*):$/
  constructor: ->
    window.eventbus.on "AppManager","newApp", @check

  # Prüft ob es eine Nativ App URL ist und filtert das : raus
  check: (url) =>
    if @nativeRE.test url
      name = @nativeRE.exec url
      @run name[1]

  # Sucht den entsprechenden App-Path von settings.nativeApps
  run: (name) ->
    # console.log name
    # console.log settings.nativeApps
    if settings.nativeApps[name]?
      @execute settings.nativeApps[name]
    else
      window.eventbus.fire "Notifications","error","Kein Pfard für #{name} hinterlegt."

  # Startet die Native App
  execute: (path) ->
    # console.log path
    path = "open #{path}" if process.platform == 'darwin'
    exec path, (error, stdout, stderr) ->
      console.log "stdout: #{stdout}"
      console.log "stderr: #{stderr}"
      if error?
        console.log "exec error: #{error}"
        window.eventbus.fire "Notifications","error",error

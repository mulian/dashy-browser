$ = jQuery = require 'jquery'
{settings} = require '../package.json'
{exec} = require 'child_process'

module.exports =
class NativeAppStarter
  nativeRE: /^([\w]*):$/
  constructor: ->
    window.eventbus.on "AppManager","newApp", @check
  check: (url) =>
    if @nativeRE.test url
      name = @nativeRE.exec url
      @run name[1]
  run: (name) ->
    if settings.nativeApps[name]?
      @execute settings.nativeApps[name]
    else
      window.eventbus.fire "Notifications","error","Kein Pfard für #{name} hinterlegt."
    # switch name
    #   when 'visio:' then @exec '/test/visio'
    #   when 'adobe:' then @exec '/adobe/path'
    #   when 'fb292065597989:' then @exec '/adobe/photoshop/path'
    #   when 'skype:' then @exec '/skype/path'
    #   when 'calc:' then @exec '/path/to/calc'
    #   when 'irfanview:' then @exec '/path/to/Irfanview'

  execute: (path) ->
    # console.log path
    path = "open #{path}" if process.platform == 'darwin'
    exec path, (error, stdout, stderr) ->
      console.log "stdout: #{stdout}"
      console.log "stderr: #{stderr}"
      if error?
        console.log "exec error: #{error}"
        window.eventbus.fire "Notifications","error",error

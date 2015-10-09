App = require './app'
{settings} = require '../package.json'
fs = require 'fs'

module.exports =
class DirectoryUpload
  uploadDir: null
  constructor: ->
    @uploadDir = settings.dirUpload.dir
    @createSubDir()
    @watch()
  deconstructor: ->
    @rmSubDir()
    @unWatch()

  createSubDir: ->
    @uploadDir = "#{@uploadDir}/upload"
    if not fs.existsSync @uploadDir
      fs.mkdirSync @uploadDir
  rmSubDir: ->
    fs.rmdirSync @uploadDir
  watch: ->
    @watch = fs.watch @uploadDir, @onDirChange
  unWatch: ->
    @watch.close()
  onDirChange: (event,filename) =>
    # console.log event
    # console.log filename
    # console.log event
    @upload filename
  upload: (filename) ->
    content = fs.readFileSync "#{@uploadDir}/#{filename}", 'utf8'
    file = @splitFileName filename
    window.eventbus.fire 'MainApp','uploadFile', {} =
      appName: file.type
      url: 'none'
      data: content
      filename: file.name
      type: file.type
  splitFileName: (filename) ->
    re = /^([\w_\-\.\$#&@!\(\)\{\}'~^\s]+)\.([\w]+)$/
    file = re.exec filename
    if file
      return {} =
        name: file[1]
        type: file[2]
    else
      return {} =
        name: filename
        type: 'undefined'


#test
# setTimeout ->
#   console.log "send!"
#   window.eventbus.fire 'MainApp','uploadFile',
#     appName: 'IPC TEST 2'
#     url: 'http://www.geileapp.de'
#     data: 'DATA!'
#     fileName: 'dateiname'
#     type: 'type'
# , 20*1000

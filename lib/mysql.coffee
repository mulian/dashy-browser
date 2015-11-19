mysql = require 'mysql'
{database} = require '../package.json'

module.exports =
class MySQL
  constructor: ->
    @connection = mysql.createConnection database
    eventbus.on 'MySQL','insertFile',@insertFile

  connect: ->
    @connection.connect() if @connection.state == 'disconnected'

  insertFile: (options) =>
    {data,filename,appName,url,now,update} = options
    user_id = eventbus.fire('Login','getId')
    console.log "user_id: #{user_id}"
    if user_id>=0 and appName?
      @connect()
      console.log @connection
      url='none' if not url?
      src='db'
      type=appName
      now = new Date() if not now?
      query=""
      if not update? or not update
        # query = " INSERT INTO file_uploads (user_id,app_name,url,src,filename,type,created,modified,data)
        #           VALUES (#{@connection.escape user_id},
        #                   #{@connection.escape appName},
        #                   #{@connection.escape url},
        #                   #{@connection.escape src},
        #                   #{@connection.escape filename},
        #                   #{@connection.escape type},
        #                   #{@connection.escape now},
        #                   #{@connection.escape now},
        #                   #{@connection.escape data})"
        query = "INSERT INTO file_uploads SET ?"
        values = {} =
          user_id: user_id
          app_name: appName
          url: url
          src: src
          filename: filename
          type: type
          created: now
          modified: now
          data: data #.replace(/[\u0800-\uFFFF]/g, '')
        # console.log "exec query: #{query}"
        @connection.query query, values, (err,da) ->
          if err
            console.log "DB error",err
          else
            eventbus.fire 'Notifications','info',"Die Datei #{filename}.#{appName} wurde hochgeladen."
      else if data? and filename?
        query = "UPDATE file_uploads SET
                  data=#{@connection.escape data},
                  modified=#{@connection.escape now}
                WHERE
                      user_id=#{@connection.escape user_id}
                  and filename=#{@connection.escape filename}
                  and type=#{@connection.escape type}"
        # console.log "exec query: #{query}"
        @connection.query query, (err,da) ->
          if err
            console.log "DB error",err
          else
            eventbus.fire 'Notifications','info',"Die Datei #{filename}.#{appName} wurde aktualisiert."
      else
        @error()
        return
    else eventbus.fire 'Notifications','info',"Die Datei #{filename}.#{appName} kann nicht hochgeladen werden. Sie sind nicht Eingeloggt."
  error: ->
    eventbus.fire 'Notifications','error','Datenbank fehler'

  # `id` int(11) NOT NULL AUTO_INCREMENT,
  # `user_id` int(11) DEFAULT NULL,
  # `group_id` int(11) DEFAULT NULL,
  # `app_name` varchar(128) DEFAULT NULL,
  # `url` varchar(256) DEFAULT NULL,
  # `src` varchar(256) NOT NULL,
  # `filename` varchar(32) DEFAULT '',
  # `type` varchar(64) NOT NULL,
  # `created` datetime NOT NULL,
  # `modified` datetime NOT NULL,
  # `data` longtext,

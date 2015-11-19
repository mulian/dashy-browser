module.exports =
class Login
  constructor: ->
    eventbus.on 'Login','setId', @setId
    eventbus.on 'Login','getId', @getId

  getId: =>
    # console.log "getId? #{@id}"
    return false if @id==undefined
    return @id

  setId: (id) =>
    if not @id? or @id!=id
      @id=id
      @changeId()

  changeId: ->
    eventbus.fire "Notifications","info","Sie sind Eingeloggt"
    console.log "logged in: #{@id}"

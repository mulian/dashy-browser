# Touch

module.exports =
class TouchCheckConditions
  constructor: (@setCall,@conditions) ->

  resetConditions: ->
    for con in @conditions
      con.checkBit=null

  allConditionsCheck: (call,e) ->
    for con in @conditions
      call.apply @,[con,e]
  checkStartConditions: (con,e) ->
    con.checkBit=true
    obj = con.conditions[e.type]
    checkFingers = ->
      fingers = obj.fingers
      fingerCount = e.touches.length
      if fingers.betweene
        if not (fingerCount>=fingers.from and fingerCount<=fingers.to)
          con.checkBit=false
      else if fingers.equals
        if fingerCount==fingers.eq
          con.checkBit=false
      con.conditions
    # check
    if con.checkBit
      checkFingers() if obj.fingers?
      
      @setCall con.callback if con.checkBit

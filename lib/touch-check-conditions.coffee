# Touch

module.exports =
class TouchCheckConditions
  constructor: (@setCall,@conditions) ->

  resetConditions: ->
    for con in @conditions
      con.checkBit=null

  allConditionsCheck: (e) ->
    for con in @conditions
      @checkStartConditions con,e
  checkStartConditions: (con,e) ->
    con.checkBit=true
    #check element?
    obj = con.conditions[e.type]

    if con.checkBit and obj.fingers?
      @checkFingers(con,e)
    if con.checkBit and obj.from?
      @checkFrom(con,e)

    if con.checkBit
      @setCall con.callback if con.checkBit

  checkFrom: (con,e) ->
    from = con.conditions[e.type].from
    if (from.left? and e.direction.left>from.left) or
       (from.right? and e.direction.right>from.right) or
       (from.top? and e.direction.top>from.top) or
       (from.bottom? and e.direction.bottom>from.bottom)
      con.checkBit=false

  checkFingers: (con,e) ->
    fingers = con.conditions[e.type].fingers
    fingerCount = e.touches.length
    if fingers.betweene?
      if not (fingerCount>=fingers.from and fingerCount<=fingers.to)
        con.checkBit=false
    else if fingers.equals?
      if fingerCount!=fingers.eq
        con.checkBit=false
    con.conditions
    # check

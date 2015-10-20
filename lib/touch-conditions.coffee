# TouchConditions


module.exports =
class TouchConditions
  _initConditions: ->
    @conditions= {} =
      touchstart: {}
      touchmove: {}
      touchend: {}
  _getCondition: ->
    return @conditions[@timing]
  _addCondition: (attr,value) ->
    @_getCondition()[attr] = value

  constructor: ->
    @_initConditions()
    @onMove() #default
    @fingers.head = @
    @move.head = @
    @from.head = @

    return @

  call: (@callback) ->
    return @


  onStart: ->
    @timing='touchstart'
    return @
  onMove: ->
    @timing='touchmove'
    return @
  onEnd: -> #no need?
    @timing='touchend'
    return @

  #move from
  from: {} =
    left: ->
      @head._addCondition 'from', {} =
        left: true
      return @head
    right: ->
      @head._addCondition 'from', {} =
        right: true
      return @head
    top: ->
      @head._addCondition 'from', {} =
        top: true
      return @head
    bottom: ->
      @head._addCondition 'from', {} =
        bottom: true
      return @head

  #move with distance to activate
  move: {} =
    X: (distance) ->
      @head._addCondition 'move', {} =
        X: distance
      return @head
    Y: (distance) ->
      @head._addCondition 'move', {} =
        Y: distance
      return @head

  fingers: {} =
    betweene: (from,to) ->
      @head._addCondition 'fingers', {} =
        from: from
        to: to
        betweene: true
      return @head
    eq: (eq) ->
      @head._addCondition 'fingers', {} =
        eq: eq
        equals: true
      return @head

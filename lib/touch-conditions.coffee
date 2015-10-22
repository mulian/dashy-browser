# touch-conditions.coffee
# Hiermit werden die Conditions erstellt.

module.exports =
class TouchConditions
  _initConditions: ->
    @conditions= {} = #there is no nee for others then touchstart or?
      touchstart: {}
      touchmove: {}
      touchend: {}
  _getCondition: ->
    return @conditions[@timing]
  _addCondition: (attr,value) ->
    @_getCondition()[attr] = value

  constructor: ->
    @_initConditions()
    @onStart() #default
    @fingers.head = @
    # @move.head = @
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
    left: (distance) ->
      @head._addCondition 'from', {} =
        left: distance
      return @head
    right: (distance) ->
      @head._addCondition 'from', {} =
        right: distance
      return @head
    top: (distance) ->
      @head._addCondition 'from', {} =
        top: distance
      return @head
    bottom: (distance) ->
      @head._addCondition 'from', {} =
        bottom: distance
      return @head

  #move with distance to activate
  # move: {} =
  #   X: (distance) ->
  #     @head._addCondition 'move', {} =
  #       X: distance
  #     return @head
  #   Y: (distance) ->
  #     @head._addCondition 'move', {} =
  #       Y: distance
  #     return @head

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

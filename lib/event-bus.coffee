module.exports =
class EventBus
  events: {}
  constructor: ->

  on: (className,channel,cb) =>
    if cb instanceof Function
      @events[className] = {} if not @events[className]?
      @events[className][channel] = [] if not @events[className][channel]?
      @events[className][channel].push cb

  fire: (className,channel,args...) =>
    if @events[className][channel]?
      for cb in @events[className][channel]
        cb.apply @,args

window.eventbus = new EventBus()

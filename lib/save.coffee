#save.coffee
# Dies ist eine Mutter Klasse für sumo-save.coffee
# Ist Sinnvoll, falls weitere save Plugins hinzukommen.

module.exports =
class Save
  constructor: ->
    window.eventbus.on "App","afterPageLoad", @check

  save: (options) ->
    window.eventbus.fire 'MainApp','uploadFile', options

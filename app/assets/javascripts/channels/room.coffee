App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (message) ->
    # alert data['message']
    jQuery(document).trigger 'received-message', message

  speak: (message)->
    @perform 'speak', {
      talker: message.talker
      text: message.text
    }
App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (message) ->
    jQuery(document).trigger 'received-message', message

  # 示例：
  # data = {
  #   text: '...'
  #   room: {
  #     type: '...', # Single, Organization, Group
  #     id: '....'
  #   }
  # }

  speak: (data)->
    console.debug 'speak', data
    @perform 'speak', data
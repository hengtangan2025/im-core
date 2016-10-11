App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (message) ->
    jQuery(document).trigger 'received-message', message


  # content = {
  #   text: '.......'
  # }

  # 发送单聊消息
  speak_single: (receiver_id, content)->
    data = {
      receiver_id: receiver_id
      content: content
    }

    console.log 'speak_single', data
    @perform 'speak_single', data

  speak_organization: (organization_id, content)->
    data = {
      organization_id: organization_id,
      content: content
    }

    console.log 'speak_organization', data
    @perform 'speak_organization', data
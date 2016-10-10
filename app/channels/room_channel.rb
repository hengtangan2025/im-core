# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(message)
    # message = {
    #   text: '......',
    # }

    data = {
      time: Time.now,
      text: message['text'],
      talker: {
        id: current_user.id.to_s,
        email: current_user.email,
        name: current_user.member.name
      }
    }

    ActionCable.server.broadcast 'room_channel', data
  end
end

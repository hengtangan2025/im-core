# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "member_channel"
    stream_from "member_channel_#{current_user.member.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  """
    示例：
    data = {
      text: '...'
      room: {
        type: '...', # Single, Organization, Group
        id: '....'
      }
    }
  """

  # 通过模型 after_create 回调
  # 交由 MessageBroadcastJob 处理广播
  def speak(data)
    ChatMessage.create!({
      member: current_user.member,
      data: data
    })
  end
end

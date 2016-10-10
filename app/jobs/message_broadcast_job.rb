class MessageBroadcastJob < ApplicationJob
  queue_as :default

  # 根据 room.type 确定接收者
  # 每个接收者一个频道
  def perform(data)
    logger.info data

    room = data[:room]
    room_id = room['id']

    channels = ['member_channel']

    if room['type'] == 'Single'
      talker_member_id = data[:talker][:member_id]

      channels = ["member_channel_#{room_id}", "member_channel_#{talker_member_id}"].uniq
    end

    channels.each do |cname|
      ActionCable.server.broadcast cname, data
    end
  end
end
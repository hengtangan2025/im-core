# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class RoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "member_channel"
    stream_from "member_channel_#{current_user.member.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # content = {
  #   text: '.......'
  # }

  # 通过模型 after_create 回调
  # 交由 MessageBroadcastJob 处理广播

  # 单聊
  def speak_single(data)
    logger.info data

    sender = current_user.member
    logger.info sender

    receiver = Member.find(data['receiver_id'])
    logger.info receiver

    content = data['content']
    logger.info content

    ChatMessage.create_single(sender, receiver, content)
  end

  # 组织机构群聊
  def speak_organization(data)
    logger.info data

    sender = current_user.member
    logger.info sender

    organization = OrganizationNode.find(data['organization_id'])
    logger.info organization

    content = data['content']
    logger.info content

    ChatMessage.create_organization(sender, organization, content)
  end
end

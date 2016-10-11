class ChatMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :room, type: Hash
  field :content, type: Hash

  belongs_to :member

  after_create {
    MessageBroadcastJob.perform_later({message_id: self.id.to_s})
  }

  def receivers
    ChatRoom.new(self.room).receivers
  end

  def client_data
    {
      id: self.id.to_s,
      time: self.created_at.to_s,
      talker: {
        member_id: self.member.id.to_s,
        name: self.member.name
      },
      room: self.room,
      content: self.content
    }
  end

  class << self
    def create_single(sender, receiver, content)
      create({
        member: sender,
        room: ChatRoom.build_single(sender, receiver).data,
        content: content
      })
    end

    def create_organization(sender, organization, content)
      create({
        member: sender,
        room: ChatRoom.build_organization(sender, organization).data,
        content: content
      })
    end
  end
end
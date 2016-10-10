class ChatMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :data

  belongs_to :member

  after_create {
    user = self.member.user

    data = {
      time: self.created_at.to_s,
      text: self.data['text'],
      room: self.data['room'],
      talker: {
        user_id: user.id.to_s,
        member_id: self.member.id.to_s,
        email: user.email,
        name: self.member.name
      }
    }

    MessageBroadcastJob.perform_later(data)
  }
end
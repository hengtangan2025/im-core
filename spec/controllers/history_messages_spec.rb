require 'rails_helper'

RSpec.describe ChatMessagesController, :type => :controller do
  describe 'GET #history' do
    it '获取历史信息' do
      sender = create(:member)
      receiver = create(:member)

      message = ChatMessage.create_single(sender, receiver, {
        text: 'hello!'
      })

      get :history, params: {room: message.room}

      expect(response).to be_success
    end
  end
end
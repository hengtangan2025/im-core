require "rails_helper"

describe ChatMessage, :type => :model do
  it '创建模型' do
    cm = ChatMessage.create({
      member: create(:member),
      data: {
        text: 'hello!'
      }
    })

    expect(ChatMessage.count).to eq 1
  end
end
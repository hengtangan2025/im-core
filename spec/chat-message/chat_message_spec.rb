require "rails_helper"

describe ChatMessage, :type => :model do
  it '创建模型' do
    u1 = create(:member)
    u2 = create(:member)

    cm = ChatMessage.create({
      member: u1,
      room: ChatRoom.build_single(u1, u2).data,
      content: {
        text: 'hello!'
      }
    })

    expect(ChatMessage.count).to eq 1
  end

  describe '单聊' do
    before {
      @sender   = create(:member)
      @receiver = create(:member)
    }

    it '获取收信人' do
      cm = ChatMessage.create_single(@sender, @receiver, {
        text: 'hello!'
      })
      expect(cm.receivers).to match_array [@sender, @receiver]
    end
  end

  describe '组织机构群聊' do
    before {
      @sender = create(:member)
      @u2 = create(:member)
      @u3 = create(:member)

      @org = create(:organization_node, members: [@sender, @u2, @u3])
    }

    it '获取收信人' do
      cm = ChatMessage.create_organization(@sender, @org, {
        text: 'hello!'
      })
      expect(cm.receivers).to match_array [@sender, @u2, @u3]
    end

    it '不在组织里的人发信息' do
      @another = create(:member)

      cm = ChatMessage.create_organization(@another, @org, {
        text: 'hello!'
      })
      expect(cm.receivers).to match_array [@sender, @u2, @u3, @another]
    end
  end
end
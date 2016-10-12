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

  describe '前端数据包装' do
    it 'client_data' do
      sender = create(:member)
      receiver = create(:member)

      message = ChatMessage.create_single(sender, receiver, {
        text: 'hello!'
      })

      expect(message.client_data).to eq({
        id: message.id.to_s,
        time: message.created_at.to_s,
        talker: {
          member_id: message.member.id.to_s,
          name: message.member.name
        },
        room: message.room,
        content: message.content
      })
    end
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

    it '不在组织里的人是否可以给组织发信息？'
    # 1. 能看就能发
    # 2. 所以所有人都能在所有机构发言
    # 3. 不作形象区分
    # 4. 刘备[总公司]

    it '上级组织的直接成员是否可以收到下级组织的信息？'
    # 1. 如果 BOSS 在上级机构，有人在下级机构发言时，除非直接 @BOSS，否则不进行红标提醒

    it '组织的下级间接成员是否可以收到该组织的信息？'

    # 发信息和看信息的权限是对等的
    # 对于某个组织机构的直接成员而言：
    # 1. 他可以可以在本机构 发/看信息
    # 2. 他可以在所有下属下级机构 发/看信息
    # 3. 他可以在所有上溯上级机构 发/看信息
    # 4. 他并不能在平级机构/平级机构的下级机构 发/看信息
    # 5. 但他能够看到平级机构/平级机构的下级机构，看到的目的是为了获得通信录和建组的时候选人

    # 提醒规则
    # 1. 如果有人在某个组织机构发言，该组织机构下面的直接成员都收到提醒
    # 2. 如果有人在某个组织机构发言，该组织机构的上级机构直接成员不会收到提醒，除非 @他
    # 3. 如果有人在某个组织机构发言，该组织机构的所有下级机构成员也不会收到提醒，
    #     @他也不行，因为他看不了这个机构里的信息
  end
end
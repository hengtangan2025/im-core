require "rails_helper"

describe ChatRoom, :type => :model do
  it '初始化' do
    room = ChatRoom.new({
      type: 'ORGANIZATION',
      key: create(:organization_node).id.to_s
    })

    expect(room.type).to eq 'ORGANIZATION'
  end

  describe '单聊' do
    before {
      @u1 = create(:member)
      @u2 = create(:member)
    }

    it '单聊时获取消息接收者' do
      room = ChatRoom.new({
        type: 'SINGLE',
        key: ChatRoom.get_single_key(@u1, @u2)
      })

      expect(room.receivers).to match_array [@u1, @u2]
    end

    it '为单聊生成 room key' do
      key1 = ChatRoom.get_single_key(@u1, @u2)
      key2 = ChatRoom.get_single_key(@u2, @u1)

      expect(key1).to eq key2
    end

    it 'build single' do
      room1 = ChatRoom.build_single(@u1, @u2)
      expect(room1.receivers).to match_array [@u1, @u2]

      room2 = ChatRoom.build_single(@u2, @u1)
      expect(room2.receivers).to match_array [@u1, @u2]
    end

    it 'data' do
      room = ChatRoom.build_single(@u1, @u2)
      expect(room.data).to eq({
        type: 'SINGLE',
        key: ChatRoom.get_single_key(@u1, @u2)
      })
    end

    it 'from_data' do
      room = ChatRoom.build_single(@u1, @u2)
      room1 = ChatRoom.new(room.data)

      expect(room).to eq room1
    end
  end
end
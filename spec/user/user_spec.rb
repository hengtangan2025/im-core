require 'rails_helper'

RSpec.describe User, type: :model do
  describe '模型关联测试' do
    it '创建用户' do
      user = User.create({
        email: 'ben7th@sina.com',
        login: 'ben7th',
        password: '123456'
      })

      expect(User.count).to eq 1
    end

    it '关联机构成员' do
      u = create(:user)
      m = create(:member, user: u)

      expect(User.count).to eq 1
      expect(Member.count).to eq 1

      expect(User.first.member).to eq Member.first
      expect(Member.first.user).to eq User.first
    end
  end
end

require "rails_helper"

RSpec.describe OrganizationNode, :type => :model do
  it '创建机构' do
    o = OrganizationNode.create({
      name: '总公司'
    })

    expect(o.name).to eq('总公司')
  end
end
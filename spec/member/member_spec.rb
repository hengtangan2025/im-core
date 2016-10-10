require "rails_helper"

describe Member, :type => :model do
  it 'create member and relation to organization_node' do
    Member.create(name: 'ben7th', organization_nodes: [create(:organization_node)], user: create(:user))

    m = Member.where(name: 'ben7th').first
    o = OrganizationNode.last

    expect(m.organization_nodes).to match_array [o]
    expect(o.members).to match_array [m]
  end

  it 'job_number' do
    Member.create(name: 'ben7th', job_number: '03281106', user: create(:user))
    expect(Member.last.job_number).to eq('03281106')
  end
end
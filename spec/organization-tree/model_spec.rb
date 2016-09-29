require "rails_helper"

describe OrganizationNode, :type => :model do
  it 'count' do
    expect(OrganizationNode.count).to eq(0)
  end

  it '创建机构' do
    o = OrganizationNode.create({name: '总公司'})
    expect(OrganizationNode.count).to eq(1)
    expect(o.name).to eq('总公司')
  end

  it 'factory girl' do
    o = create(:organization_node)
    expect(OrganizationNode.count).to eq(1)
    expect(o.name).to eq('test-o-1')
  end

  it '添加下级机构' do
    o0 = create(:organization_node)
    o1 = create(:organization_node)

    o0.children << o1
    expect(o0.children.count).to eq(1)
    expect(o0.children).to match_array([o1])
    expect(o1.parent).to eq(o0)
  end

  describe 'yaml 导入' do
    it '解析 yaml' do
      data = YAML.load File.read File.join(Rails.root, 'spec', 'organization-tree', 'sample-tree.yaml')
      expect(data['name']).to eq('总公司')
      expect(data['children'][0]['name']).to eq('北京分公司')
    end

    it '根据 yaml 导入数据' do
      expect(OrganizationNode.count).to eq(0)
      OrganizationNode.from_yaml File.read File.join(Rails.root, 'spec', 'organization-tree', 'sample-tree.yaml')
      expect(OrganizationNode.count).to eq(6)

      obj = OrganizationNode.where(name: '北京分公司').first
      expect(obj.children.count).to eq(2)

      ohd = OrganizationNode.where(name: '海淀区办事处').first
      expect(ohd.leaf?).to be true
    end

    it 'roots' do
      expect(OrganizationNode.roots.count).to eq(0)
      OrganizationNode.from_yaml File.read File.join(Rails.root, 'spec', 'organization-tree', 'sample-tree.yaml')
      expect(OrganizationNode.roots.count).to eq(1)
    end
  end

  describe '数据包装' do
    it '树数据包装' do
      OrganizationNode.from_yaml File.read File.join(Rails.root, 'spec', 'organization-tree', 'sample-tree.yaml')
      root = OrganizationNode.roots.first
      expect(root.name).to eq('总公司')
      tree_data = root.tree_data

      expect(tree_data[:name]).to eq('总公司')
      expect(tree_data[:children].map{ |x| x[:name] }).to match_array(['北京分公司', '上海分公司', '广州分公司'])
    end

    it '节点数据包装' do
      OrganizationNode.from_yaml File.read File.join(Rails.root, 'spec', 'organization-tree', 'sample-tree.yaml')
      node = OrganizationNode.where(name: '北京分公司').first
      node_data = node.node_data

      expect(node_data[:name]).to eq('北京分公司')
      expect(node_data[:parent][:name]).to eq('总公司')
      expect(node_data[:children].count).to eq(2)
    end
  end
end
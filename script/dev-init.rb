# 此脚本用来初始化开发环境数据
# 注意！会清空原有数据

p '清空组织机构和成员，以及对应用户'
OrganizationNode.destroy_all
Member.destroy_all
User.destroy_all

p '清空历史消息'
ChatMessage.destroy_all

p '导入示例组织机构和成员，以及对应用户'
OrganizationNode.from_yaml File.read File.join(Rails.root, 'spec', 'organization-tree', 'sample-tree-with-members.yaml')
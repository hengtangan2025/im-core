# 此脚本用来初始化开发环境数据
# 注意！会清空原有数据

p '清空组织机构和成员'
OrganizationNode.destroy_all
Member.destroy_all

p '导入示例组织机构和成员'
OrganizationNode.from_yaml File.read File.join(Rails.root, 'spec', 'organization-tree', 'sample-tree-with-members.yaml')
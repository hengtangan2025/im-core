# 树实现
# https://github.com/benedikt/mongoid-tree
# https://ruby-china.org/topics/11147

class OrganizationNode
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree

  field :name, type: String

  def self.from_yaml(yaml_string)
    data = YAML.load yaml_string

    root = OrganizationNode.create(name: data['name'])
    _from_yaml_r(root, data['children'])
  end

  private
    def self._from_yaml_r(parent, children_data)
      return if children_data.blank?
      children_data.each do |child_data|
        child = OrganizationNode.create(name: child_data['name'], parent: parent)
        _from_yaml_r(child, child_data['children'])
      end
    end
end

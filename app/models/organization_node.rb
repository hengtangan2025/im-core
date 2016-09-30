# 树实现
# https://github.com/benedikt/mongoid-tree
# https://ruby-china.org/topics/11147

class OrganizationNode
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Tree

  field :name, type: String

  has_and_belongs_to_many :members

  class << self
    def from_yaml(yaml_string)
      data = YAML.load yaml_string

      members = (data['members'] || []).map {|m|
        Member.where(job_number: m['job_number']).first_or_create(name: m['name'])
      }
      root = OrganizationNode.create(name: data['name'], members: members)

      _from_yaml_r(root, data['children'])
    end

    def import_sample
      OrganizationNode.from_yaml File.read File.join(Rails.root, 'spec', 'organization-tree', 'sample-tree.yaml')
    end

    private
      def _from_yaml_r(parent, children_data)
        return if children_data.blank?
        children_data.each do |child_data|

          members = (child_data['members'] || []).map {|m|
            Member.where(job_number: m['job_number']).first_or_create(name: m['name'])
          }

          child = OrganizationNode.create(name: child_data['name'], parent: parent, members: members)
          _from_yaml_r(child, child_data['children'])
        end
      end
  end

  def tree_data
    {
      id: id.to_s,
      name: name,
      children: (children || []).map { |c|
        c.tree_data
      }
    }
  end

  def node_data
    {
      id: id.to_s,
      name: name,
      parent: parent.present? ? {
        id: parent.id.to_s,
        name: parent.name
      } : nil,
      children: (children || []).map { |c|
        {
          id: c.id.to_s,
          name: c.name
        }
      }
    }
  end

end

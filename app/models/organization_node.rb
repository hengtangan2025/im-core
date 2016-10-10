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
      _create_with_members(data)
    end

    private
      def _from_yaml_r(parent, children_data)
        (children_data || []).each do |child_data|
          _create_with_members(child_data, parent)
        end
      end

      def _create_with_members(data, parent = nil)
        members = (data['members'] || []).map { |m|
          Member.where(job_number: m['job_number']).first_or_create(name: m['name'])
        }
        node = OrganizationNode.create(name: data['name'], members: members, parent: parent)
        _from_yaml_r(node, data['children'])
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

  def tree_data_with_members
    {
      id: id.to_s,
      name: name,
      children: (children || []).map { |c|
        c.tree_data_with_members
      },
      members: (members || []).map { |m|
        {
          id: m.id.to_s,
          name: m.name,
          job_number: m.job_number
        }
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

  def node_data_with_members
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
      },
      members: (members || []).map { |m|
        {
          id: m.id.to_s,
          name: m.name,
          job_number: m.job_number
        }
      }
    }
  end

end

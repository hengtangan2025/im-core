class IndexController < ApplicationController
  def index
    roots = OrganizationNode.roots.map { |x|
      { 
        id: x.id.to_s, 
        name: x.name,
        path: chat_path(oid: x.id)
      }
    }

    @component_name = 'OrganizationsTreesPage'
    @component_data = {
      tree_roots: roots
    }
  end
end
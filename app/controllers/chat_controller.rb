class ChatController < ApplicationController
  def show
    root = OrganizationNode.find params[:oid]

    @component_name = 'ChatPage'
    @component_data = {
      organization_tree: root.tree_data
    }
  end
end
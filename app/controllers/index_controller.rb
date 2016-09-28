class IndexController < ApplicationController
  def index
    # @component_name = 'IndexPage'
    # @component_data = {}
    redirect_to trees_organizations_path
  end
end
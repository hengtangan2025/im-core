class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def default_render
    if @component_name.present?
      @component_name = @component_name.camelize
      
      respond_to do |format|
        format.html { render template: '/index/component' }
        format.json { render json: @component_data }
      end
    else
      super
    end
  end
end
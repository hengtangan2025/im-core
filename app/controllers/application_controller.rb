class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def default_render
    if @component_name.present?
      @component_name = @component_name.camelize
      return render template: '/index/component'
    else
      super
    end
  end
end
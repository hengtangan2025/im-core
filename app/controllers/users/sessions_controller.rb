class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    @component_name = 'AuthSignInPage'
    @component_data = {
      submit_url: session_path(resource_name),
      users: User.all.map { |x|
        {
          email: x.email,
          name: x.member.name,
          password: '123456'
        }
      }
    }
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end

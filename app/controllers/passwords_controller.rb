class PasswordsController < Devise::PasswordsController
  layout 'application'

  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    @user = User.find_by_reset_password_token(params[:reset_password_token])
  end
end

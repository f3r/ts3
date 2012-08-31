class PasswordsController < Devise::PasswordsController
  layout 'application'

  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    @user = User.find_by_reset_password_token(params[:reset_password_token])

    unless @user && @user.reset_password_period_valid?
      flash[:error] = "The link to set your password expired. Please login of click on 'Forgot Password'"
      redirect_to new_user_session_path
      return
    end
  end
end

module AuthenticationHelper

  def logged_in?
    user_signed_in?
  end

  def is_agent?
    return false unless logged_in?
    user = current_user
    user && user['role'] == 'agent'
  end

  def is_admin?
    return false unless logged_in?
    user = current_user
    user && (user['role'] == 'admin' or user['role'] == 'superadmin')
  end

  def current_token
    current_user.authentication_token if current_user
  end

  def login_required
    authenticate_user!
  end
end

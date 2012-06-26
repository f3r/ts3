module AuthenticationHelper

  def current_user?(user)
    current_user && current_user.id == user.id
  end

  def logged_in?
    user_signed_in?
  end

  def is_agent?
    user = current_user
    return false unless user
    user.agent?
  end

  def is_admin?
    user = current_user
    return false unless user
    user.admin?
  end

  def login_required
    authenticate_user!
  end
end

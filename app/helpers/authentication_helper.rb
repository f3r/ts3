module AuthenticationHelper

  def logged_in?
    cookies['authentication_token'].present?
  end

  def sign_in(session)
    cookies['authentication_token'] = session.authentication_token
  end

  def sign_out
    cookies['authentication_token'] = nil
  end

  def current_token
    cookies['authentication_token']
  end

  def current_user
    @current_user ||= Heypal::User.show('access_token' => current_token)
  end

  def current_user=(user)
    @current_user = user
  end
end

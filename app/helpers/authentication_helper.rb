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

end

module AuthenticationHelper

  def logged_in?
    session['authentication_token'].present?
  end

  def sign_in(_session)
    session['authentication_token'] = _session.authentication_token
  end

  def sign_out
    session['authentication_token'] = nil
  end

  def current_token
    session['authentication_token']
  end

  def login_required
    redirect_to login_path unless logged_in?
  end

end

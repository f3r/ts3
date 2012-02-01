module AuthenticationHelper

  def logged_in?
    session['authentication_token'].present? && current_user
  end

  def is_agent?
    return false unless logged_in?
    user = current_user
    user && user['role'] == 'agent'
  end
  
  def sign_in(_session)
    session['authentication_token'] = _session['authentication_token']
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

  def current_user
    @current_user = @current_user || session['current_user'] || Heypal::User.show('access_token' => current_token)
  rescue RestClient::Unauthorized
    # We got an invalid user
    session['authentication_token'] = nil    
  end

  def current_user=(user)
    @current_user = user
  end
end

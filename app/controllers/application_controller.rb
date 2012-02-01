class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticationHelper
  include LookupsHelper
  include AvailabilitiesHelper
  before_filter :instantiate_controller_and_action_names
  before_filter :set_locale

  def set_locale
    I18n.locale = get_current_language
  end

  def params_with_token(resource)
    p = params[resource]
    p[:access_token] = current_token
    p 
  end

  private
  
  def instantiate_controller_and_action_names
    @current_action = action_name
    @current_controller = controller_name
  end
  
  def store_location
    session[:user_return_to] = request.url unless params[:controller] == "sessions"
  end

  def after_sign_in_path
    session[:user_return_to] || '/places'
  end
  
end

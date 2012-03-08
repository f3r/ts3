class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticationHelper
  include LookupsHelper
  include AvailabilitiesHelper
  before_filter :instantiate_controller_and_action_names
  before_filter :set_locale
  before_filter :change_preferences

  def set_locale
    I18n.locale = get_current_language
  end

  def params_with_token(resource)
    p = params[resource]
    p[:access_token] = current_token
    p 
  end
  
  def change_preferences
    if params.delete(:change_preference)
      preference = if params.key?("pref_language")
        :pref_language
      elsif params.key?("pref_currency")
        :pref_currency
      elsif params.key?("pref_size_unit")
        :pref_size_unit
      end

      value = params.delete(preference)
      # Set to cookies
      cookies[preference] = value

      if logged_in?
        session['current_user'] = current_user.change_preference(preference, value, current_token)
        redirect_to params
      else
        redirect_to params.merge(:trigger_signup => true)
      end
    end
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
    session.delete(:user_return_to) || '/places'
  end
  
end

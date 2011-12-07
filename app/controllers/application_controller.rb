class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticationHelper
  include LookupsHelper
  include AvailabilitiesHelper
  before_filter :instantiate_controller_and_action_names

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

end

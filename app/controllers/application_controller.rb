class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticationHelper
  include LookupsHelper
  include AvailabilitiesHelper

  def params_with_token(resource)
    p = params[resource]
    p[:access_token] = current_token
    p 
  end
end

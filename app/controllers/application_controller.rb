class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticationHelper
  include LookupsHelper

  def params_with_token(resource)
    p = params[resource]
    p[:access_token] = current_token
    p 
  end

  def error_messages(codes)
    ret = []
    codes.each do |field, error_codes|
      error_codes.each do |error_code|
        ret << "#{field.humanize}: #{t("errors.#{error_code}")}"
      end
    end

    ret
  end
end

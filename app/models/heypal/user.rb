class Heypal::User < Heypal::Base
  
  set_resource_path '/users.json'

  class << self
    def create(params = {})
      self.new.merge(request('/users/sign_up.json', :post, params))
    end

    def confirm(params = {})
      result = request('/users/confirmation.json', :post, params)
      result['stat'] == 'ok'
    end

    def resend_confirmation(params = {})
      result = request('/users/resend_confirmation.json', :post, params)
      result['stat'] == 'ok'
    end

    def reset_password(params = {})
      result = request('/users/password.json', :post, params)
      result['stat'] == 'ok'
    end

    def confirm_reset_password(params = {})
      result = request('/users/password.json', :put, params)
      result['stat'] == 'ok'
    end
  end

  def success?
    self['user_id'].present?
  end

end

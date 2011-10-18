class Heypal::Session < Heypal::Base

  set_resource_path '/users/sign_in.json'

  class << self
    def create(options = {})
      self.new.merge(request('/users/sign_in.json', :post, options))
    end
  end

  def valid?
    self['stat'] == 'ok'
  end

  def authentication_token
    self['authentication_token']
  end

end

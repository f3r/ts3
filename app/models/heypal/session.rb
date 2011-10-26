class Heypal::Session < Heypal::Base

  set_resource_path '/users/sign_in.json'

  class << self
    def create(options = {})
      self.new.merge(request('/users/sign_in.json', :post, options))
    rescue
      self.new({'stat' => 'fail'})
    end

    def signin_via_facebook(options = {})
      self.new.merge(request('/users/facebook/sign_in.json', :post, options))
    end

    def signin_via_twitter(options = {})
      self.new.merge(request('/users/twitter/sign_in.json', :post, options))
    end

    def signin_via_oauth(provider, options = {})
      request("/users/#{provider}/sign_in.json", :post, options)
    end    

    def create_oauth(options = {})
      self.new.merge(request('/authentications.json', :post, options))
    end
  end

  def valid?
    self['stat'] == 'ok'
  end

  def authentication_token
    self['authentication_token']
  end

end

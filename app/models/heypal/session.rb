class Heypal::Session < Heypal::Base

  set_resource_path '/users/sign_in.json'

  class << self
    def create(options = {})
      self.new.merge(request('/users/sign_in.json', :post, options))
    rescue
      self.new({'stat' => 'fail'})
    end

    def signin_via_oauth(provider, options = {})
      self.new.merge(request("/users/oauth/sign_in.json", :post, options))
    rescue RestClient::Unauthorized
      self.new({'stat' => 'fail'})
    end    

    def create_oauth(options = {})
      self.new.merge(request('/authentications.json', :post, options))
    end

    def destroy(options = {})
      request("/authentications/#{options['id']}.json", :delete, options)
    end
  end

  def valid?
    puts self.inspect
    self['stat'] == 'ok'
  end

  def authentication_token
    self['authentication_token']
  end

end

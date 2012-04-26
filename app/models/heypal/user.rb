class Heypal::User < Heypal::Base

  set_resource_path '/users.json'

  @@attributes = %w(id first_name last_name gender email password password_confirmation terms oauth_provider oauth_token oauth_uid phone_mobile passport_number birthdate access_token avatar_url avatar current_token)
  @@attributes.each { |attr| attr_accessor attr.to_sym }

  define_attribute_methods = @@attributes

  validates :first_name, :last_name, :email, :password, :password_confirmation, :presence => true, :on => :create
  validates :password, :confirmation => true, :on => :create
  validates :terms, :acceptance => true, :on => :create

  class << self
    def create(params = {})
      self.new.unserialize(request('/users/sign_up.json', :post, params))
    end

    def confirm(params = {})
      result = request("/users/confirmation.json?confirmation_token=#{params['confirmation_token']}", :get)
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
      result
    end

    def show(params = {})
      result = request("/users.json?access_token=#{params['access_token']}", :get, params)
      self.new(result['user'].merge('current_token' => params['access_token']))
    end

    def info(params = {})
      result = request("/users/#{params['id']}/info.json", :get, params)
      self.new(result['user'])
    end
    
    def places(params = {})
      result = request("/users/#{params['id']}/places.json?status=published", :get, params)
      if result['stat'] == 'ok' && result.key?("places")
        result['places']
      else
        []
      end
    end

    def update(params = {})
      result = request("/users.json?access_token=#{params['access_token']}", :put, params)
      result['stat'] == 'ok'
    end

    def list(params = {})
      result = request("/authentications.json?access_token=#{params['access_token']}", :get, params)
    end

    def facebook_info(params = {})
      result = request("/users/facebook/info.json?access_token=#{params['access_token']}", :get, params)
      if result['stat'] == 'ok'
        result['user_info']
      else
        nil
      end
    end
    
    def cancel_email_change(params = {})
      result = request("/users/confirmation.json?access_token=#{params['access_token']}", :delete)
      result['stat'] == 'ok'
    end
    
    def feedback(params = {})
      request('/users/feedback.json', :post, params)
    end
  end

  def initialize(params = {})
    deserialize(params)
    self['oauth_token'] = {'provider' => @oauth_provider, 'uid' => @oauth_uid, 'credentials' => {'token' => @oauth_token, 'secret' => ''}}

    @auth_token = self['auth_token']
  end

  def success?
    self['user_id'].present?
  end

  def new_record?
    self['id'].blank? && self.access_token.blank?
  end

  def save
    if new_record?
      @response = self.class.request('/users/sign_up.json', :post, self.to_hash)        
    else
      @response = self.class.request("/users.json?access_token=#{self.access_token}", :put, self.to_hash)
    end

    if @response['stat'] == 'ok'
      return true
    else
      Rails.logger.info @response.inspect
      # TODO: Standardize the error message
      self.errors.add(:base, @response['err'])
      return false
    end
  end

  def fetch!
    result = request("/users/#{self['user_id']}/info.json")
  end

  def full_name
    [first_name,last_name].join(' ')
  end
  
  def avatar_url
    @avatar_url ||= fetch_profile_picture_url
  end
  
  def fetch_profile_picture_url
    if oauth_provider == "facebook"
      avatar = "https://graph.facebook.com/#{oauth_uid}/picture"
    elsif oauth_provider == "twitter"
      user = RestClient.get("https://api.twitter.com/1/users/show.json?user_id=#{oauth_uid}")
      user_info = JSON.parse(user)
      avatar = user_info['profile_image_url']
    end
  end
  
  def change_preference(preference, value, token = nil)
    access_token = self.current_token || token
    if self.class.update('access_token' => access_token, preference => value)
      self[preference] = value
      self.class.show('access_token' => self.current_token)
    end
  end
end

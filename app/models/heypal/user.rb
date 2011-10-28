class Heypal::User < Heypal::Base

  set_resource_path '/users.json'

  @@attributes = %w(first_name last_name email password password_confirmation terms oauth_provider oauth_token oauth_uid)
  @@attributes.each { |attr| attr_accessor attr.to_sym }

  define_attribute_methods = @@attributes

  validates :first_name, :last_name, :email, :password, :password_confirmation, :presence => true
  validates :password, :confirmation => true
  validates :terms, :acceptance => true

  class << self
    def create(params = {})
      self.new.merge(request('/users/sign_up.json', :post, params))
    end

    def confirm(params = {})
      result = request("/users/confirmation.json?confirmation_token=#{params['confirmation_token']}", :get)
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

      Rails.logger.info result.inspect
      result['stat'] == 'ok'
    end

    def show(params = {})
      result = request("/users.json?access_token=#{params['access_token']}", :get, params)
      result['user']
    end

    def update(params = {})
      result = request("/users.json?access_token=#{params['access_token']}", :put, params)
    end

    def list(params = {})
      result = request("/authentications.json?access_token=#{params['access_token']}", :get, params)
    end

  end

  def initialize(params = {})
    @@attributes.each do |attr|
      instance_variable_set("@#{attr}", params[attr])
      self[attr] = params[attr]
    end
  end

  def success?
    self['user_id'].present?
  end

  def save
    response = self.class.request('/users/sign_up.json', :post, self.to_hash)
    if response['stat'] == 'ok'
      return true
    else
      Rails.logger.info response.inspect
      # TODO: Standardize the error message
      self.errors.add(:base, response['err'])
      return false
    end
  end

  def fetch!
    result = request("/users/#{self['user_id']}/info.json")
  end

end

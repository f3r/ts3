class Heypal::User < Heypal::Base

  set_resource_path '/users.json'

  @@attributes = %w(name email password password_confirmation terms)
  @@attributes.each { |attr| attr_accessor attr.to_sym }

  define_attribute_methods = @@attributes

  validates :name, :email, :password, :password_confirmation, :presence => true
  validates :password, :confirmation => true
  validates :terms, :acceptance => true

  class << self
    def create(params = {})
      self.new.merge(request('/users/sign_up.json', :post, {:name => params[:name], :email => params[:email], :password => params[:password]}))
      #self.new.merge(request('/users/sign_up.json', :post, params))
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
      result['stat'] == 'ok'
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
      self.errors << {'error' => response['message']}
      return false
    end
  end

end

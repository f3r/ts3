class User < ActiveRecord::Base
  devise :database_authenticatable, # Encrypting Password and validating authenticity of user
         :registerable,             # Users can sign up :)
         :recoverable,              # Reset user password
         :trackable,                # Tracks:
                                    #   * sign_in_count      - Increased every time a sign in is made (by form, openid, oauth)
                                    #   * current_sign_in_at - A tiemstamp updated when the user signs in
                                    #   * last_sign_in_at    - Holds the timestamp of the previous sign in
                                    #   * current_sign_in_ip - The remote ip updated when the user sign in
                                    #   * last_sign_in_ip    - Holds the remote ip of the previous sign in
         :validatable,              # Email/Pwd validation
         :token_authenticatable     # Generate auth token and validates it

  attr_accessible :first_name, :last_name, :email, :gender, :birthdate, :timezone, :phone_mobile, :avatar, :avatar_url, :password, :password_confirmation,
                  :remember_me, :pref_language, :pref_currency, :pref_size_unit, :pref_city, :role, :passport_number, :skip_welcome

  attr_accessor :oauth_provider, :oauth_token, :oauth_uid, :avatar_url, :terms

  before_save :ensure_authentication_token
  after_create :send_on_create_welcome_instructions

  def full_name
    [first_name,last_name].join(' ')
  end

  private

  def send_on_create_welcome_instructions
    RegistrationMailer.welcome_instructions(self).deliver unless skip_welcome
  end
end
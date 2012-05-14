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
         :token_authenticatable,    # Generate auth token and validates it
         :omniauthable              # OAuth support

  include User::Social

  attr_accessible :first_name, :last_name, :email, :gender, :birthdate, :timezone, :phone_mobile, :avatar, :avatar_url, :password, :password_confirmation,
                  :remember_me, :pref_language, :pref_currency, :pref_size_unit, :pref_city, :role, :passport_number

  attr_accessor :terms, :skip_welcome

  has_many :authentications,  :dependent => :destroy

  has_attached_file :avatar,
     :styles => {
       :thumb  => "100x100#",
       :medium => "300x300#",
       :large  => "600x600>"
      },
     :path => "/avatars/:id/:style.:extension",
     :default_url => "none",
     :convert_options => { 
       :large => "-quality 80",
       :medium => "-quality 80",
       :thumb => "-quality 80" }

  before_save :ensure_authentication_token, :check_avatar_url
  after_create :send_on_create_welcome_instructions
  
  scope :consumer, where("role = 'user'")
  scope :agent,    where("role = 'agent'")
  scope :admin,    where("role = 'admin' or role = 'superadmin'")
  
  def full_name
    [first_name,last_name].join(' ')
  end

  def name=(a_name)
    self.first_name, self.last_name = a_name.split(' ', 2)
  end

  private

  def send_on_create_welcome_instructions
    RegistrationMailer.welcome_instructions(self).deliver unless skip_welcome
  end

  # checks if avatar_url is set and updates the avatar if avatar_url is an image
  def check_avatar_url
    if self.avatar_url
      remote_avatar = open(self.avatar_url) rescue nil
      self.avatar = remote_avatar if remote_avatar
    end
  end
end
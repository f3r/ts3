require 'declarative_authorization/maintenance'
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
                  :remember_me, :pref_language, :pref_currency, :pref_size_unit, :pref_city, :role, :passport_number, :address_attributes, :delete_avatar

  belongs_to :prefered_city, :class_name => 'City', :foreign_key => 'pref_city'

  # TODO: check if we need this
  # has_many :addresses,        :dependent => :destroy

  has_one :address
  has_one :bank_account

  has_many :authentications,  :dependent => :destroy
  has_many :products,         :dependent => :destroy
  has_many :comments,         :dependent => :destroy
  has_many :favorites,        :dependent => :destroy
  has_many :alerts,           :dependent => :destroy

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

  attr_accessor :delete_avatar, :terms, :skip_welcome
  accepts_nested_attributes_for :address, :update_only => true

  before_save :ensure_authentication_token, :check_avatar_url
  before_save :check_delete_avatar
  after_create :send_on_create_welcome_instructions

  scope :consumer, where("role = 'user'")
  scope :agent,    where("role = 'agent'")
  scope :admin,    where("role = 'admin' or role = 'superadmin'")

  # Creates a new user with a random password automatically
  def self.auto_signup(name, email)
    first_name, last_name = name.split(' ', 2)
    password = Devise.friendly_token[0,20]
    user = self.new(
      :first_name => first_name,
      :last_name => last_name,
      :email => email,
      :password => password,
      :password_confirmation => password
    )

    user.generate_set_password_token

    Authorization::Maintenance::without_access_control do
      if user.save
        UserMailer.auto_welcome(user).deliver
      end
    end

    user
  end

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def anonymized_name
    initials = []
    initials << "#{first_name[0]}." if first_name
    initials << "#{last_name[0]}." if last_name
    initials.join(' ')
  end

  def age
    return unless self.birthdate
    now = Time.now.utc.to_date
    now.year - birthdate.year - ((now.month > birthdate.month || (now.month == birthdate.month && now.day >= birthdate.day)) ? 0 : 1)
  end

  def name=(a_name)
    self.first_name, self.last_name = a_name.split(' ', 2)
  end

  def admin?
    self.role == 'admin' || self.role == 'superadmin'
  end

  def agent?
    self.role == 'agent'
  end

  def consumer?
    self.role == 'user'
  end

  def role_symbols
    [role.to_sym]
  end

  def change_preference(pref, value)
    if pref =~ /pref_/
      self.update_attribute(pref, value)
    end
  end

  def generate_set_password_token
    # We use the saeme mechanism as password reset
    self.generate_reset_password_token
  end

  # Retrieves the other published products of this user
  def other_published_products(except = nil)
    products = SiteConfig.product_class.published
    products = products.where('products.id <> ?', except.product.id) if except
    products
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

  def check_delete_avatar
    if delete_avatar
      self.avatar.clear if avatar && !avatar.dirty?
    end
  end

end
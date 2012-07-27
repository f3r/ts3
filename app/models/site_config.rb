class SiteConfig < ActiveRecord::Base

  after_save :reset_cache

  has_attached_file :fav_icon,
    :path => "static/favicon.ico"

  has_attached_file :logo,
    :path => "static/logo.png"

  has_attached_file :photo_watermark, {
    :path => "watermarks/photowatermark.jpg"
  }

  def self.instance
    @instance = @instance || SiteConfig.first || SiteConfig.new
  end

  def self.mail_sysadmins
    %w(fer@heypal.com nico@heypal.com).join(', ')
  end

  def self.method_missing(name, *args)
    if self.running_migrations?
      return self.default_to_constant(name)
    end
    if self.instance.respond_to?(name.to_s)
      val = self.instance.send(name.to_s) if self.instance
      if !val.nil?
        val
      else
        # Backward compatibility with config constants
       self.default_to_constant(name)
      end
    else
      super
    end
  end

  def self.running_migrations?
    @migrating ||= !self.table_exists?
  end

  def self.default_to_constant(name)
    name.to_s.upcase.safe_constantize
  end

  # get a list of color_schemes the directory, get name from the first line
  def self.color_schemes
    color_schemes = []
    basedir = Rails.root + "app/assets/stylesheets/color_schemes/"
    css_files = Dir.glob(basedir + '*')
    css_files.each do |directory|
      file = directory + "/index.less"
      description = File.open(file) {|f| f.readline}.gsub("/*", "").gsub("*/", "").strip!
      name = directory.gsub(basedir.to_s,"")
      color_schemes << [description, name] if description && name
    end
    return color_schemes
  end

  def self.product_class
    PRODUCT_CLASS_NAME.constantize
  end

  def self.product_plural
    I18n.t('product_name_plural')
  end

  def self.product_name
    I18n.t('product_name')
  end

  def price_units
    units = []
    units << :sale      if self.enable_price_sale?
    units << :per_month if self.enable_price_per_month?
    units << :per_week  if self.enable_price_per_week?
    units << :per_day   if self.enable_price_per_day?
    units << :per_hour  if self.enable_price_per_hour?
    units
  end

  def transaction_length_options
    units = []
    units << ['month(s)', 'months'] if self.enable_price_per_month?
    units << ['week(s)',  'weeks']  if self.enable_price_per_week?
    units << ['day(s)',   'days']   if self.enable_price_per_day?
    units << ['hour(s)',  'hours']  if self.enable_price_per_hour?
    units
  end

  def price_unit
    units = self.price_units
    if units.blank?
      raise "Must enable a price unit"
    else
      units.first
    end
  end

  protected

  def self.reset_cache
    @instance = nil
  end

  def reset_cache
    self.class.reset_cache
  end
end

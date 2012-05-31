class SiteConfig < ActiveRecord::Base
  after_commit :reset_cache

  def self.instance
    @instance ||= SiteConfig.first || SiteConfig.new
  end

  def self.mail_sysadmins
    %w(fer@heypal.com nico@heypal.com).join(', ')
  end

  def self.method_missing(name, *args)
    if self.running_migrations?
      return self.default_to_constant(name)
    end
    if self.instance.attributes.has_key?(name.to_s)
      val = self.instance.attributes[name.to_s] if self.instance
      if val.present?
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
    name.to_s.upcase.constantize
  end

  # get a list of color_schemes the directory, get name from the first line
  def self.color_schemes
    color_schemes = [['Default', 'none']]
    css_files = Dir[Rails.root + 'app/assets/stylesheets/color_schemes/*']
    css_files.find_all{|file|File.extname(file) == '.less'}.each do |file|
      filename = File.basename(file, ".css.less")
      name = File.open(file) {|f| f.readline}.gsub("/* ", "").gsub(" */", "")
      color_schemes << [name, filename] if name && filename
    end
    return color_schemes
  end

  protected

  def reset_cache
    @instance = nil
  end
end

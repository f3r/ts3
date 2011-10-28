class Heypal::Photo < Heypal::Base  
  include ::Paperclip
  include ::Paperclip::Glue
  include ActiveSupport::Callbacks

  attr_accessor :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at

  # Just some methods for paperclip we don't need
  class << self
    def after_save(options = {})
    end

    def before_destroy(options = {})
    end    

    def after_destroy(options = {})
    end
  end

  def save
    save_attached_files
  end

  def id
    "1"
  end

  has_attached_file :photo, :styles => { :large => "480x480#", :medium => "300x300>", :thumb => "100x100>", :tiny => "48x48" }
  
end

Paperclip.interpolates :id_partition do |attachment, style|
  attachment.instance.id.to_s.scan(/.{4}/).join("/")
end

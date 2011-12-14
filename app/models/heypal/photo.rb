class Heypal::Photo < Heypal::Base  
  include ::Paperclip
  include ::Paperclip::Glue
  include ActiveSupport::Callbacks

  attr_accessor :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at, :place_id, :photo_id

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
    @place_id
  end

  def uniq_id
    @photo_id
  end

  has_attached_file :photo, { :styles => { :large => "451x299>", :medium => "216x144>", :medsmall => "150x100>", :small => "106x70>", :tiny => "40x40!" },
                                 :path => "places/:id/photos/:uniq_id/:style.:extension",
                                 :storage => :s3, 
                                 :s3_credentials => {
                                   :access_key_id => S3_ACCESS_KEY_ID,
                                   :secret_access_key => S3_SECRET_ACCESS_KEY
                                   :bucket => S3_BUCKET,
                                 },
                                 :s3_protocol => "http"
  }

end

Paperclip.interpolates :id_partition do |attachment, style|
  attachment.instance.id.to_s.scan(/.{4}/).join("/")
end

Paperclip.interpolates(:s3_alias_url) do |attachment, style|
  "#{attachment.s3_protocol(style)}://#{attachment.s3_host_alias}/#{attachment.path(style).gsub(%r{^/}, "")}"
end unless Paperclip::Interpolations.respond_to? :s3_alias_url
Paperclip.interpolates(:s3_path_url) do |attachment, style|
  "#{attachment.s3_protocol(style)}://#{attachment.s3_host_name}/#{attachment.bucket_name}/#{attachment.path(style).gsub(%r{^/}, "")}"
end unless Paperclip::Interpolations.respond_to? :s3_path_url
Paperclip.interpolates(:s3_domain_url) do |attachment, style|
  "#{attachment.s3_protocol(style)}://#{attachment.bucket_name}.#{attachment.s3_host_name}/#{attachment.path(style).gsub(%r{^/}, "")}"
end unless Paperclip::Interpolations.respond_to? :s3_domain_url
Paperclip.interpolates(:asset_host) do |attachment, style|
  "#{attachment.path(style).gsub(%r{^/}, "")}"
end unless Paperclip::Interpolations.respond_to? :asset_host

module Paperclip
  module Interpolations
    def uniq_id attachment, style_name
      attachment.instance.uniq_id
    end
  end
end

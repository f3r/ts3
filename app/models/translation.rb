class Translation < ActiveRecord::Base
  scope :template,   where("`translations`.`key` LIKE ?", 'template.%')
  scope :places,     where("`translations`.`key` LIKE ?", 'places.%')
  scope :users,      where("`translations`.`key` LIKE ?", 'users.%')
  scope :workflow,   where("`translations`.`key` LIKE ?", 'workflow.%')
  scope :inquiries,  where("`translations`.`key` LIKE ?", 'inquiries.%')
  scope :messages,   where("`translations`.`key` LIKE ?", 'messages.%')
  scope :mailers,    where("`translations`.`key` LIKE ?", 'mailers.%')

  after_save    :delete_cache
  after_destroy :delete_cache

  has_many :versions, :class_name => 'TranslationVersion', :foreign_key => "translation_id", :order => "id DESC", :dependent => :destroy

  before_update do |r|
    r.versions.create({:value => r.value_was}) if r.value_changed?
  end

  # Was changed from the admin interface?
  def modified?
    self.versions.any?
  end

  def other_language(locale)
    translation = Translation.where(:key => self.key, :locale => locale).first
  end

  private
  # TODO: get cache_key name
  def delete_cache
    # namespace = "i18n"
    # Rails.cache.delete("i18n/#{namespace}/#{self.locale}/#{self.key.hash}/")
    # /#{USE_INSPECT_HASH ? options.inspect.hash : options.hash}
    logger.debug "Cleaning cache"
    I18n.cache_store.clear
  end
end
class Translation < ActiveRecord::Base
  scope :template,  where("`translations`.`key` LIKE ?", 'template.%')
  scope :places,  where("`translations`.`key` LIKE ?", 'places.%')
  scope :users,  where("`translations`.`key` LIKE ?", 'users.%')
  scope :workflow,  where("`translations`.`key` LIKE ?", 'workflow.%')
  scope :inquiries,  where("`translations`.`key` LIKE ?", 'inquiries.%')
  scope :messages,  where("`translations`.`key` LIKE ?", 'messages.%')

  after_commit :delete_cache

  def other_language(locale)
    translation = Translation.where(:key => self.key, :locale => locale).first
  end

  private
  # TODO: get cache_key name
  def delete_cache
    # namespace = "i18n"
    # Rails.cache.delete("i18n/#{namespace}/#{self.locale}/#{self.key.hash}/")
    # /#{USE_INSPECT_HASH ? options.inspect.hash : options.hash}
    I18n.cache_store.clear
  end
end
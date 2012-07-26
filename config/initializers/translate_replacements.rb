# Override the translation method so that it always includes some default replacement variables
def options_with_replacements(options)
  options.merge({
    :site_name => SiteConfig.site_name,
    :site_url => SiteConfig.site_url,
    :site_tagline => SiteConfig.site_tagline,
    :support_email => SiteConfig.support_email,
    :support_email_link => "<a href='mailto:#{SiteConfig.support_email}'>#{SiteConfig.support_email}</a>".html_safe,
    :product_name => SiteConfig.product_name,
    :product_plural => SiteConfig.product_plural
  })
end

module ActionView::Helpers::TranslationHelper
  def translate_with_replacements(key, options={})
    translate_without_replacements(key, options_with_replacements(options))
  end

  alias_method_chain :translate, :replacements
  alias :t :translate
end

module AbstractController
  module Translation
    def translate_with_replacements(key, options={})
      translate_without_replacements(key, options_with_replacements(options))
    end

    alias_method_chain :translate, :replacements
    alias :t :translate
  end
end
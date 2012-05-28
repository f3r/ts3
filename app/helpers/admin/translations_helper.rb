module Admin::TranslationsHelper

  def translation_value_with_links(translation,locale)    
      if locale == translation.locale
        html = CGI::escapeHTML(translation.value)
        html << "<br />"
        html << link_to('Edit', edit_admin_translation_path(translation), :class => 'member_link')
        html << link_to('Delete', admin_translation_path(translation),:method => :delete ,:class => 'member_link',:confirm => 'Are you sure?')
      else
        other = translation.other_language(locale)
        if other
          html = CGI::escapeHTML(other.value)
          html << "<br />"
          html << link_to('Edit', edit_admin_translation_path(other), :class => 'member_link')
          html << link_to('Delete', admin_translation_path(other),:method => :delete ,:class => 'member_link',:confirm => 'Are you sure?')
        else
          html = link_to "Create translation", new_admin_translation_path(:locale => locale, :key => translation.key)
        end
      end
      raw html
  end

end
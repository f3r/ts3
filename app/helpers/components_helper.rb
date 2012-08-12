module ComponentsHelper
  def breadcrumb(levels, current_title, &block)
    content_tag :ul, :class => 'breadcrumb' do
      html = ''
      levels.each do |label, url|
        html << content_tag(:li, link_to(label, url), :class => 'back')
        html << content_tag(:span, '&raquo;'.html_safe, :class => 'divider')
      end
      current_class = 'active'
      if levels.blank?
        current_class << ' root'
      end
      html << content_tag(:li, current_title, :class => current_class)
      html << capture(&block) if block
      html.html_safe
    end
  end

  def previous_wizard_tab(current_tab)
    current_pos = wizard_tabs.index(current_tab.to_sym)
    if current_pos > 0
      wizard_tabs[current_pos - 1]
    end
  end

  def next_wizard_tab(current_tab)
    current_pos = wizard_tabs.index(current_tab.to_sym)
    if current_pos < wizard_tabs.length - 1
      wizard_tabs[current_pos + 1]
    end
  end
end
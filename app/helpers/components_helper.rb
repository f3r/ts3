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

  def wizard_tabs
    unless @wizard_tabs
      @wizard_tabs = []
      @wizard_tabs << :general
      @wizard_tabs << :photos    if SiteConfig.photos?
      @wizard_tabs << :panoramas if SiteConfig.panoramas?
      @wizard_tabs << :amenities if AmenityGroup.any?
      @wizard_tabs << :pricing
      #tabs << :calendar if SiteConfig.calendar?
    end
    @wizard_tabs
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
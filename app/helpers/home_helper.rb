module HomeHelper
  def login_path_with_ref
    black_list = ['/', '/signup', '/login', '/users/login', '/users/signup']
    current_path = request.path

    if current_path && !black_list.include?(current_path)
      new_user_session_path(:ref => request.path)
    else
      new_user_session_path
    end
  end

  def signup_path_with_ref
    black_list = ['/', '/signup', '/login', '/users/login', '/users/signup']
    current_path = request.path

    if current_path && !black_list.include?(current_path)
      new_user_registration_path(:ref => request.path)
    else
      new_user_registration_path
    end
  end

  def menu_link_to(label, path)
    current_path = request.path
    active_class = (request.path == path)? 'active' : ''
    content_tag :li, :class => active_class do
      link_to label, path
    end
  end

  def home_photo_faq_path
    '/photo-faq'
  end

  def main_menu
    html = ""
    menu = MenuSection.main
    return unless menu

    menu.cmspages.each do |p|
      html << menu_link_to(p.page_title, p.link)
    end
    html.html_safe
  end

  def help_menu
    content_tag(:li, {:class => 'dropdown'}) do
      html1 = ""
      html1 << content_tag(:a, {:class => "dropdown-toggle", 'data-toggle' => "dropdown", :href => "#"}) do
        html = "Help"
        html << content_tag(:b, "", {:class => 'caret'})
        html.html_safe
      end

      html1 << content_tag(:ul, {:class => 'dropdown-menu', :style => 'width:200px'}) do
        html = ""
        menu = MenuSection.help
        if menu
          menu.cmspages.all.each do |p|
            html << content_tag(:li,{}) do
              link_to p.page_title, p.link
            end
          end
        end
        html.html_safe
      end
      html1.html_safe
    end
  end

  def footer_menu
    menu = MenuSection.footer
    return unless menu

    links = menu.cmspages.collect do |p|
      link_to(p.page_title, p.link)
    end
    links.join(' | ').html_safe
  end

  def render_menu_section(menu_section, &block)
    if menu_section.mtype == 1
      #get the first page
      cmspage = menu_section.cmspages.first
      menu_link_to(cmspage.page_title, "/" + cmspage.page_url)
    else
      content_tag(:li, {:class => 'dropdown'}) do
        html1 = ""
        html1 << content_tag(:a, {:class => "dropdown-toggle", 'data-toggle' => "dropdown", :href => "#"}) do
          html = menu_section.display_name
          html << content_tag(:b, "", {:class => 'caret'})
          html.html_safe
        end

        html1 << content_tag(:ul, {:class => 'dropdown-menu', :style => 'width:200px'}) do
          html = ""
          menu_section.cmspages.all.each do |p|
            html << content_tag(:li,{}) do
              content_tag(:a,{}) do
                link_to p.page_title, "/" + p.page_url
              end
            end
          end
          html << capture(&block) if block
          html.html_safe
        end
        html1.html_safe
      end
    end
  end
end

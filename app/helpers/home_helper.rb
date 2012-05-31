module HomeHelper
  def login_path_with_ref
    black_list = ['/', '/signup', '/login']
    current_path = request.path

    if current_path && !black_list.include?(current_path)
      new_user_session_path(:ref => request.path)
    else
      new_user_session_path
    end
  end

  def signup_path_with_ref
    black_list = ['/', '/signup', '/login']
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

  def current_city
    if logged_in? && current_user.prefered_city.present?
      return current_user.prefered_city
    end

    if cookies[:pref_city_id]
      return City.find(cookies[:pref_city_id])
    end

    return City.active.first
  end

  def home_photo_faq_path
    '/photo-faq'
  end
  
  
  def main_menu
    html = ""
    MenuSection.main.cmspages.each do |p|
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
        MenuSection.help.cmspages.all.each do |p|
          html << content_tag(:li,{}) do
            content_tag(:a,{}) do 
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
    html = ""
    menu_cnt = MenuSection.footer.cmspages.count
    MenuSection.footer.cmspages.each do |p|
      page_title = menu_cnt > 1 ? " #{p.page_title} " : " #{p.page_title}"
      html << link_to(page_title, p.link) + " |"
      menu_cnt = menu_cnt - 1
    end
    # Strip out the last " |"
    html[0..html.length-3].html_safe
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

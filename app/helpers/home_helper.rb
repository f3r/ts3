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
end

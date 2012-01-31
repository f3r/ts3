module HomeHelper
  def login_path_with_ref
    black_list = ['/', '/signup', '/login']
    current_path = request.path

    if current_path && !black_list.include?(current_path)
      login_path(:ref => request.path)
    else
      login_path
    end
  end
end

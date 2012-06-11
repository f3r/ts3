ActiveAdmin::Dashboards.build do

  section "Users", :priority => 1 do
    div do
      stats = User.histo_counts(:cummulative => false)
 
      render('/admin/chart', :title => 'Users', :stats => stats)
    end
  end
  
  section "Places", :priority => 1 do
    div do
      stats = Place.histo_counts(:cummulative => false)
 
      render('/admin/chart', :title => 'Places', :stats => stats)
    end
  end

  section "Data Funnel", :priority => 40 do
    div do
      image_tag("http://chart.apis.google.com/chart?" + AdminDashboard.conversion_funnel_as_g_chart_params)
    end
  end
  

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end

end

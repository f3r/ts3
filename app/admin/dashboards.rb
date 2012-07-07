require_dependency 'ar_stats'
require_dependency 'active_admin_ext'
require_dependency 'google_funnel_chart'
require_dependency 'google_visualization'

klass = SiteConfig.product_class

ActiveAdmin::Dashboards.build do

  section "Users", :priority => 1 do
    div do
      stats = User.histo_counts(:cummulative => false)

      render('/admin/chart', :title => 'Users', :stats => stats)
    end
  end

  section klass.name.pluralize, :priority => 1 do
    div do
      stats = klass.histo_counts(:cummulative => false)

      render('/admin/chart', :title => klass.name.pluralize, :stats => stats)
    end
  end

  section "Users Pipeline", :priority => 2 do
    div do
      google_funnel_chart(AdminDashboard.user_funnel, {:height => 140, :width => 550, :bar_color => "005577"})
    end
  end

  section "Agents Pipeline", :priority => 40 do
    div do
      google_funnel_chart(AdminDashboard.agent_funnel, {:height => 140, :bar_color => "0099BB", :width => 550})
    end
  end

  section "Transaction - Funnel", :priority => 60 do
    div do
      google_funnel_chart(AdminDashboard.transaction_funnel, {:bar_color => "007799", :width => 550})
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

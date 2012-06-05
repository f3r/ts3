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
  

end

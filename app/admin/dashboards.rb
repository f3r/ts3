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

end

include PlacesHelper
DynamicSitemaps::Sitemap.draw do
  
  # default per_page is 50.000 which is the specified maximum.
  # TODO
  # Will move this config
  per_page 1000

  url root_url, :last_mod => DateTime.now, :change_freq => 'daily', :priority => 1
  
  Place.published.each do |place|
    url seo_place_path(place), :last_mod => place.updated_at, :change_freq => 'monthly', :priority => 0.8
  end
  
end
#TODO: Make this service/place independent
include PlacesHelper
DynamicSitemaps::Sitemap.draw do

  # default per_page is 50.000 which is the specified maximum.
  # TODO
  # Will move this config
  per_page 1000

  url root_url, :last_mod => DateTime.now, :change_freq => 'daily', :priority => 1

  Product.published.each do |prod|
    url seo_product_url(prod), :last_mod => prod.updated_at, :change_freq => 'monthly', :priority => 0.8
  end

end
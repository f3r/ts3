module Admin::CitiesHelper
  def public_city_path(city)
    url_for("/#{city.slug}")
  end

  def city_links_column(city)
    html = link_to('Details', admin_city_path(city), :class => 'member_link')
    html << link_to('Edit', edit_admin_city_path(city), :class => 'member_link')
    html << link_to_if(city.active, 'View Public', public_city_path(city), :class => 'member_link', :target => '_blank')
  end

  def static_image_map(product)
    if product.geocoded?
      image_tag "http://maps.googleapis.com/maps/api/staticmap?size=400x200&center=#{product.lat},#{product.lon}&zoom=14&sensor=false"
    end
  end
end
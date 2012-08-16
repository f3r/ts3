DynamicSitemaps::Sitemap.draw do
  # default per_page is 50.000 which is the specified maximum.
  # TODO
  # Will move this config
  per_page 1000

  url root_url, :last_mod => DateTime.now, :change_freq => 'daily', :priority => 1
  
  #Have the active cities in the sitemap
  City.active.each do |city|
    url "#{root_url}#{city.slug}", :change_freq => 'monthly', :priority => 0.6
  end
  
  #Get the cmspages linked with the menu sections
  page_ids = []
  [:main, :help, :footer].each do |ms_name|
    menu_section = MenuSection.find_by_name(ms_name)
    pages = menu_section.cmspages
    for page in pages
      if not page.kind_of?(ExternalLink) and not page.id.in?(page_ids)
        url "#{root_url}#{page.page_url}", :change_freq => 'monthly', :priority => 0.7
        page_ids << page.id
      end
    end
  end
  
  SiteConfig.product_class.published.each do |prod|
    url seo_product_url(prod), :last_mod => prod.updated_at, :change_freq => 'monthly', :priority => 0.8
  end

end
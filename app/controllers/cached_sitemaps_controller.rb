class CachedSitemapsController < SitemapsController
  layout false
  
  before_filter :set_headers
  
  # TODO: Make the expires configurable
  caches_action :sitemap, {:expires_in => 24.hours}, :cache_path => "sitemap-xml"
  
  protected
  #Not sure why I need to set this, but when the page is cached, rails processes the action as html and sends the headers accordingly
  def set_headers
   headers["Content-Type"] = "application/xml; charset=utf-8" 
   if not ActionController::Base.perform_caching  or not Rails.cache.exist? ActiveSupport::Cache.expand_cache_key "sitemap-xml", :views
     headers["Last-Modified"] = DateTime.now.httpdate
   end   
  end
end
namespace :sitemap_submission do
  desc "Push squarestays sitemap to search engines"
  task  :submit_sitemap => :environment do
    SITE_URL = SiteConfig.site_url
    log_path = File.join(Rails.root, 'log/sitemap.log')
    log_file = File.open(log_path, 'a')
    log_file.sync = true
    
    SitemapLogger = Logger.new(log_file)
    
    SEARCH_ENGINES = {
      :google => "http://www.google.com/webmasters/tools/ping?sitemap=%s",
     #:ask => "http://submissions.ask.com/ping?sitemap=%s", /**** Error : getaddrinfo: Name or service not known ****/
      :bing => "http://www.bing.com/webmaster/ping.aspx?siteMap=%s",
      :live => "http://webmaster.live.com/ping.aspx?siteMap=%s",
    }
    SitemapLogger.info Time.now
    
    SEARCH_ENGINES.each do |name, url|
      request = url % CGI.escape("#{SITE_URL}/sitemap.xml")  
      SitemapLogger.info "  Pinging #{name} with #{request}"
      if Rails.env == "production"
        response = Net::HTTP.get_response(URI.parse(request))
        SitemapLogger.info "    #{response.code}: #{response.message}"
        SitemapLogger.info "    Body: #{response.body}"
      end
    end
  end
end
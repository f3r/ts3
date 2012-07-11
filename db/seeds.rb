USERS = [['Jeremy Snyder', 'jeremy.a.snyder@gmail.com'],
 ['Fer Santana', 'fernandomartinsantana@gmail.com'],
 ['Nicolas Gaivironsky', 'nico@heypal.com']]

site_config = SiteConfig.first_or_create

site_config.logo ||= File.open("#{Rails.root}/db/rake_seed_images/logo.png")
site_config.fav_icon ||= File.open("#{Rails.root}/db/rake_seed_images/favicon.png")
site_config.custom_meta ||= %{
  <meta name="robots" content="noodp" />
  <meta name="slurp" content="noydir" />
}
site_config.static_assets_path ||= "http://s3.amazonaws.com/#{Paperclip::Attachment.default_options[:bucket]}/static"
site_config.mailer_sender ||= 'The Sharing Engine <noreply@thesharingengine.com>'
site_config.mail_bcc ||= USERS.collect{|n, e| e}.join(', ')
site_config.support_email ||= 'support@thesharingengine.com'
site_config.save!

unless Locale.exists?(:code => "en")
  Locale.create({:code => "en", :name => "English", :name_native => "English", :position => 1, :active => true})
end

unless City.exists?(name: "Singapore")
  City.create!(name: "Singapore", lat: 1.28967, lon: 103.85, country: "Singapore", country_code: "SG", active: true)
end

unless Currency.exists?(currency_code: "USD")
  Currency.create!(name: "Us Dollar", symbol: "$", country: "USA", currency_code: "USD", active: 1, position: 1, currency_abbreviation: "US")
end

unless Gallery.exists?(name: "homepage")
  home_gallery = Gallery.create!(name: "homepage")
  home_gallery.gallery_items.create!(
  	photo: File.open("#{Rails.root}/db/rake_seed_images/carousel.png"),
  	link: "http://www.thesharingengine.com", 
  	label: 'Get Started Today!', 
  	position: 1, 
  	active: 1
  )
 end

USERS.each do |name, email|
  unless User.exists?(email: email)
    u = User.new
    u.name = name
    u.email = email
    u.role = 'admin'
    u.password = '3ngin3'
    u.skip_welcome = true
    u.save!
  end
end

unless MenuSection.exists?(name: 'main')
  MenuSection.create_defaults
end

#Cmspage.create(
#     hw = MenuSection.create(name: 'how-it-works', display_name: 'How it Works?')
#     p = Cmspage.find_by_url 'how-it-works'
#     hw.cmspages << p

#     why = MenuSection.create(name: 'why-squarestays', display_name: 'Why SquareStays?')
#     p = Cmspage.find_by_url 'why'
#     why.cmspages << p

#     help = MenuSection.create(name: 'help', display_name: 'Help')
#     p = Cmspage.find_by_url 'how-it-works'
#     help.cmspages << p
#     p = Cmspage.find_by_url 'why'
#     help.cmspages << p
#     p = Cmspage.find_by_url 'singapore-city-guide'
#     help.cmspages << p
#     p = Cmspage.find_by_url 'hong-kong-city-guide'
#     help.cmspages << p
#     p = Cmspage.find_by_url 'kuala-lumpur-city-guide'
#     help.cmspages << p

# Cmspage.create({:page_title => "Home page - Footer", :page_url => 'home_page_footer', 
# :description => "<div class=\"tease-social\"><hr class=\"style-two\" />\r\n<div class=\"links\"><img src=\"https://s3.amazonaws.com/squarestays-static/icon.fb.jpg\" alt=\"\" width=\"30px\" height=\"30px\" /> <span class=\"social-text\"> <a href=\"https://www.facebook.com/squarestays\">Join us on Facebook</a> </span> <img src=\"https://s3.amazonaws.com/squarestays-static/icon.tw.jpg\" alt=\"\" width=\"30px\" height=\"30px\" /> <span class=\"social-text\"> <a href=\"https://twitter.com/#!/Squarestays\">Follow us on Twitter</a> </span> <img src=\"https://s3.amazonaws.com/squarestays-static/icon.rss.png\" alt=\"\" width=\"25px\" height=\"25px\" /> <span class=\"social-text\"> <a href=\"http://blog.squarestays.com\">Read our Blog</a> </span></div>\r\n<hr class=\"style-two\" /></div>\r\n<div class=\"tease-blurb\">\r\n<div class=\"tease-header\">Why should you use SquareStayz?</div>\r\n<div class=\"row\"><img src=\"http://s3.amazonaws.com/squarestays-static/flx.jpg\" alt=\"SquareStayz offers flexible, high-quality accommodations for you. SquareStayz is the destination site to find your perfect short-term or medium-term stay.\" /> <img src=\"http://s3.amazonaws.com/squarestays-static/qlty.jpg\" alt=\"SquareStayz works with professional Agents and Landlords to ensure a comfortable and professional experience you can trust.\" /> <img src=\"http://s3.amazonaws.com/squarestays-static/afrd.jpg\" alt=\"SquareStayz offers high quality and distinct properties - have your own home away from home for less then the price of a 5 star hotel.\" /></div>\r\n</div>\r\n<div class=\"trust\">\r\n<div class=\"row\"><img title=\"Small World Group\" src=\"http://s3.amazonaws.com/squarestays-static/swg.jpg\" alt=\"\" /> <img title=\"National Research Foundation\" src=\"http://s3.amazonaws.com/squarestays-static/nrf.jpg\" alt=\"\" /> <img title=\"PropNex\" src=\"http://s3.amazonaws.com/squarestays-static/prnx.jpg\" alt=\"\" /> <img title=\"Far East Organization\" src=\"http://s3.amazonaws.com/squarestays-static/feo.jpg\" alt=\"\" /></div>\r\n</div>", 
# :active => true, :mandatory => true})    

#     Page.create({:page_title => "Error - 404", :page_url => 'error_404', 
#     :description => "<div class=\"error-page row\">\r\n<div class=\"span10 offset1\">\r\n<h2>We could not find the page you requested</h2>\r\n<div class=\"error-test\">We apologize for the inconvenience</div>\r\n<img class=\"error-image\" src=\"/assets/404pic.png\" alt=\"404pic\" /></div>\r\n</div>", 
#     :active => true, :mandatory => true})
    
#     Page.create({:page_title => "Error - 500", :page_url => 'error_500', 
#     :description => "<div class=\"error-page row\">\r\n<div class=\"span10 offset1\">\r\n<h2>A Problem occured on this page</h2>\r\n<p class=\"errro-subhead\">Our technicians have been notified of this error</p>\r\n<span class=\"error-text\">We apologize for the inconvenience</span> <img class=\"error-image\" src=\"/assets/500pic.png\" alt=\"500pic\" /></div>\r\n</div>", 
#     :active => true, :mandatory => true})
        

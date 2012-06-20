City.create(name: "Singapore", lat: 1.28967, lon: 103.85, country: "Singapore", country_code: "SG", active: true )
Currency.create(name: "Us Dollar", symbol: "$", country: "USA", currency_code: "USD", active: 1, position: 1,currency_abbreviation:"US" )
siteConfig = SiteConfig.find_or_create_by_site_name(:site_name => 'SquareStayz')
siteConfig.fav_icon = File.open("#{Rails.root}/db/rake_seed_images/favicon.ico")
siteConfig.save!
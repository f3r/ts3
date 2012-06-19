unless City.exists?(name: "Singapore")
  City.create!(name: "Singapore", lat: 1.28967, lon: 103.85, country: "Singapore", country_code: "SG", active: true)
end

unless Currency.exists?(currency_code: "USD")
  Currency.create!(name: "Us Dollar", symbol: "$", country: "USA", currency_code: "USD", active: 1, position: 1, currency_abbreviation: "US")
end

siteConfig = SiteConfig.first_or_create
unless siteConfig.logo?
  siteConfig.logo = File.open("#{Rails.root}/db/rake_seed_images/tse_logo_bg.png")
  siteConfig.save!
end
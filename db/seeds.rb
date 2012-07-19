USERS = [
  ['Jeremy Snyder', 'jeremy.a.snyder@gmail.com'],
  ['Fer Santana', 'fernandomartinsantana@gmail.com'],
  ['Nicolas Gaivironsky', 'nico@heypal.com']
]

site_config = SiteConfig.first_or_create
site_config.logo = File.open("#{Rails.root}/db/rake_seed_images/logo.png") unless site_config.logo?
site_config.fav_icon = File.open("#{Rails.root}/db/rake_seed_images/favicon.png") unless site_config.fav_icon?
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

unless PreferenceSection.any?
  PreferenceSection.create({:name => "Language", :code => "language_pref", :position => 1, :active => true})
  PreferenceSection.create({:name => "Currency", :code => "currency_pref", :position => 2, :active => true})
  PreferenceSection.create({:name => "Size Unit", :code => "size_unit_pref", :position => 3, :active => true})
  PreferenceSection.create({:name => "Speed Unit", :code => "speed_unit_pref", :position => 4, :active => true})
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

unless Cmspage.count >= 9
  # Render a haml view
  app = HeyPalFrontEnd::Application
  app.routes.default_url_options = { :host => '' }
  controller = ApplicationController.new
  view = ActionView::Base.new("db/pages", {}, controller)
  view.class_eval do
    include ApplicationHelper
    include app.routes.url_helpers
  end

  pages = [
    ['Terms', 'terms', 'footer'],
    ['Fees', 'fees'],
    ['Privacy Policy', 'privacy', 'footer'],
    ['Contact Information', 'contact', 'footer'],
    ['Home page - Footer', 'home_page_footer'],
    ['Error - 404', 'error_404'],
    ['Error - 500', 'error_500'],
    ['How it works', 'how-it-works', 'help'],
    ['Why', 'why', 'help']
  ]

  pages.each do |title, url, menu_name|
    next if Cmspage.exists?(page_url: url)

    html = view.render(template: url)
    page = Cmspage.create(
      page_title: title,
      page_url: url,
      description: html,
      active: true,
      mandatory: true
    )
    if menu_name
      menu = MenuSection.find_by_name(menu_name)
      menu.cmspages << page
    end
  end
end

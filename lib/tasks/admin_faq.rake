namespace :admin_faq do
  desc "Creating FAQ items"
  task :create_faq => :environment do
    require Rails.root.to_s + '/db/admin_faq/seeds.rb'
  end
end
namespace :seeds do
  desc "Load initial data for silvertroopers"
  task :services => :environment do
    require Rails.root.to_s + '/db/services/seeds.rb'
  end

  task :properties => :environment do
    require Rails.root.to_s + '/db/properties/seeds.rb'
  end
end
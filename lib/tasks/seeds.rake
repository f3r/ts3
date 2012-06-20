namespace :seeds do
  desc "Load initial data for silvertroopers"
  task :silvertroopers => :environment do
    require Rails.root.to_s + '/db/services/seeds.rb'
  end
end
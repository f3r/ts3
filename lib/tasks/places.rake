namespace :places do
  desc "Regenerate geolocation lat/long for all places"
  task :geolocation_refresh => :environment do
    Place.all.each do |place|
      puts "Refreshing: [#{place.id}][#{place.country_name}] #{place.title}"
      begin
        place.geocode
      rescue Exception => e
        puts e.inspect
      end
    end
  end
end
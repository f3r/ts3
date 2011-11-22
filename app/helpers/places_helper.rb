module PlacesHelper

  # Amenities
  def amenities_group_1 
    [
      ['Doorman', :amenities_doorman],
      ['Elevator', :amenities_elevator],
      ['Gym', :amenities_gym],
      ['Kitchen', :amenities_kitchen],
      ['Parking Included', :amenities_parking_included],
      ['Pool', :amenities_pool],
      ['Tennis', :amenities_tennis],
    ]
  end

  # Furnishings 
  def amenities_group_2
    [
      ['Buzzer/Intercom', :amenities_buzzer_intercom],
      ['Cable TV', :amenities_cable_tv],
      ['Dryer', :amenities_dryer],    
      ['Airconditioning', :amenities_aircon], 
      ['Heating', :amenities_heating],
      ['Hot Water', :amenities_hot_water], 
      ['TV', :amenities_tv],
      ['Washer', :amenities_washer],
    ]
    #
    #[
      #['Couch', :amenities_couch],
      #['Bedroom Furniture', :amenities_bedroom],
      #['Dining room furniture', :amenities_dining], 
      #['Kitchenware', :amenities_kitchenware],
      #['Dishware', :amenities_dishware]
    #]
  end

  # Misc
  def amenities_group_3
    [
      ['Breakfast', :amenities_breakfast],
      ['Internet', :amenities_internet],
      ['Smoking Allowed', :amenities_smoking_allowed],
      ['Suitable for Events', :amenities_suitable_events],      
      ['Internet Wifi', :amenities_internet_wifi],
      ['Family Friendly', :amenities_family_friendly],
      ['Pets Allowed', :amenities_pets_allowed],
      ['Handicap', :amenities_handicap],
      ['Jacuzzi', :amenities_jacuzzi],      
    ]   
  end

  def render_photo(photo)
    p = photo['photo']

    photo_title = p['name'].present? ? p['name'] : t(:no_caption)
    raw "<div class='photo_image' id='image-#{p['id']}'><img class='photo' src='#{p['small']}' data-small='#{p['small']}' data-medium='#{p['medium']}'  data-large='#{p['large']}' data-tiny='#{p['tiny']}' data-original='#{p['original']}' data-id='#{p['id']}' data-filename='#{p['filename']}' data-name='#{p['name']}' /></div><p class='photo_title'>#{photo_title}</p>"
  end
  
  def render_photo_title(photo)

  end

  def location(place)
    [place['city_name'], place['country_name']].join(',')
  end
end

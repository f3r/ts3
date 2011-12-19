module PlacesHelper

  # Amenities
  def amenities_group_1 
    [
      ['Kitchen', :amenities_kitchen],
      ['Hot Tub', :amenities_hot_water], 
      ['Elevator', :amenities_elevator],
      ['Parking Space', :amenities_parking_included],
      ['Heating', :amenities_heating],
      ['Handicap accessible', :amenities_handicap],
      ['Doorman', :amenities_doorman],
      ['Air Conditioning', :amenities_aircon], 
      ['Buzzer/Intercom', :amenities_buzzer_intercom],
    ]
  end

  # Furnishings 
  def amenities_group_2
    [
      ['Internet', :amenities_internet],
      ['TV', :amenities_tv],
      ['Dryer', :amenities_dryer],    
      ['Wifi', :amenities_internet_wifi],
      ['Cable TV', :amenities_cable_tv],
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
      ['Pets Allowed', :amenities_pets_allowed],
      ['Breakfast', :amenities_breakfast],
      ['Smoking Allowed', :amenities_smoking_allowed],
      ['Suitable for Events', :amenities_suitable_events],      
      ['Family Friendly', :amenities_family_friendly],
    ]   
  end

  def amenities_group_4
    [
      ['Gym', :amenities_gym],
      ['Jacuzzi', :amenities_jacuzzi],      
      ['Tennis', :amenities_tennis],
      ['Pool', :amenities_pool],
    ]
  end

  def render_photo(photo)
    p = photo['photo']

    photo_title = p['name'].present? ? truncate(p['name'], :length => 23) : t(:no_caption)
    raw "<div class='photo_image' id='image-#{p['id']}'><img class='photo' src='#{p['small']}' data-small='#{p['small']}' data-medium='#{p['medium']}' data-medsmall='#{p['medsmall']}' data-large='#{p['large']}' data-tiny='#{p['tiny']}' data-original='#{p['original']}' data-id='#{p['id']}' data-filename='#{p['filename']}' data-name='#{p['name']}' data-trunc-name='#{truncate(p['name'], :length => 23)}' /></div><p class='photo_title'>#{photo_title}</p>"
  end
  
  def render_photo_title(photo)

  end

  def location(place)
    [place['city_name'], place['country_name']].join(',')
  end

  def display_place_amenities(place)
    place_amenities = []
    all_amenities = amenities_group_1 + amenities_group_2 + amenities_group_3 + amenities_group_4
    all_amenities.each do |a|
      if place[a[1].to_s]
        place_amenities << a[0]
      end
    end

    place_amenities
  end
  
  # FIXME: collapse all availabilities so that they don't show several overlapped
  # def cleanup_availabilities(foo)
  #   foo.each do |f|
  #     
  #   end
  # end

  def month_count(days)
    date = Date.today
    days_count = Time.days_in_month(date.month, date.year)
    months = 'none'
    unless days.nil? || days.eql?(0)
      if days < days_count
        months = pluralize(days, 'day')
      elsif days == days_count
        months = pluralize((days/days_count), 'month')
      elsif days > days_count
        month = days/days_count
        days_count = (date - Date.today.advance(:months => "-#{month}".to_i)).to_i
        months = "#{pluralize((days - days_count), 'day')}, #{pluralize((month), 'month')}"
      end
    end
    months
  end
end

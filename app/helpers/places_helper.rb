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
      ['Hot Tub', :amenities_hot_tub],
      ['Jacuzzi', :amenities_jacuzzi],      
      ['TV', :amenities_tv],
      ['Washer', :amenities_washer],
    ]
  end

  # Misc
  def aminities_group_3
    [
      ['Breakfast', :amenities_breakfast],
      ['Internet', :amenities_internet],
      ['Smoking Allowed', :amenities_smoking_allowed],
      ['Suitable for Events', :amenities_suitable_events],      
      ['Internet Wifi', :amenities_internet_wifi],
      ['Family Friendly', :amenities_family_friendly],
      ['Pets Allowed', :amenities_pets_allowed],
      ['Handicap', :amenities_handicap],
    ]   
  end
end

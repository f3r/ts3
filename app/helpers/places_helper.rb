module PlacesHelper

  # Amenities
  def amenities_group_1 
    [
      [t(:kitchen), :amenities_kitchen],
      [t(:hot_water), :amenities_hot_water], 
      [t(:elevator), :amenities_elevator],
      [t(:parking_included), :amenities_parking_included],
      [t(:heating), :amenities_heating],
      [t(:handicap), :amenities_handicap],
      [t(:doorman), :amenities_doorman],
      [t(:aircon), :amenities_aircon], 
      [t(:buzzer_intercom), :amenities_buzzer_intercom],
    ]
  end

  # Furnishings 
  def amenities_group_2
    [
      [t(:internet), :amenities_internet],
      [t(:tv), :amenities_tv],
      [t(:dryer), :amenities_dryer],    
      [t(:internet_wifi), :amenities_internet_wifi],
      [t(:cable_tv), :amenities_cable_tv],
      [t(:washer), :amenities_washer],
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
      [t(:pets_allowed), :amenities_pets_allowed],
      [t(:breakfast), :amenities_breakfast],
      [t(:smoking_allowed), :amenities_smoking_allowed],
      [t(:suitable_events), :amenities_suitable_events],
      [t(:family_friendly), :amenities_family_friendly],
    ]
  end

  def amenities_group_4
    [
      [t(:gym), :amenities_gym],
      [t(:jacuzzi), :amenities_jacuzzi],
      [t(:hot_tub), :amenities_hot_tub],
      [t(:tennis), :amenities_tennis],
      [t(:pool), :amenities_pool],
    ]
  end

  def render_photo(photo)
    p = photo['photo']

    photo_title = p['name'].present? ? truncate(p['name'], :length => 23) : t(:no_caption)
    html = content_tag :div, :class => 'photo_image', :id => "image-#{p['id']}" do
      image_tag(p['small'], :data => {
        :id    => p['id'],
        :large => p['large'],
        :name  => p['name'],
        :trunc_name => truncate(p['name'], :length => 23)
      }).html_safe
    end
    html << content_tag(:p, photo_title)

    html
    #raw "<div class='photo_image' id='image-#{p['id']}'><img class='photo' src='#{p['small']}' data-small='#{p['small']}' data-medium='#{p['medium']}' data-medsmall='#{p['medsmall']}' data-large='#{p['large']}' data-tiny='#{p['tiny']}' data-original='#{p['original']}' data-id='#{p['id']}' data-filename='#{p['filename']}' data-name='#{p['name']}' data-trunc-name='#{truncate(p['name'], :length => 23)}' alt='#{p['filename']}'/></div><p class='photo_title'>#{photo_title}</p>"
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

  def get_carousel_photoset(place)
    hacked_photo_set = place['photos'].dup
    # to faken cons to still iterate and display for the last image the first and second image
    hacked_photo_set << place['photos'][0] << place['photos'][1]

    return hacked_photo_set
  end
  
  # FIXME: collapse all availabilities so that they don't show several overlapped
  # def cleanup_availabilities(foo)
  #   foo.each do |f|
  #     
  #   end
  # end

  # TODO: unused, delete? 
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

  def seo_place_path(place)
    result = place['title'].dup
    result.gsub!(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
    result.gsub!(/[^\w_ \-]+/i, '')   # Remove unwanted chars.
    result.gsub!(/[ \-]+/i, '-')      # No more than one of the separator in a row.
    result.gsub!(/^\-|\-$/i, '')      # Remove leading/trailing separator.
    result.downcase!

    if place['city_id'] == 2
      "/hong_kong/#{place['id']}-#{result}"
    else
      "/singapore/#{place['id']}-#{result}"
    end
  end

  def place_type_filters(place_type_counts)
    filters = []
    place_type_counts.each do |type_name, count|
      if count > 0
        place_type = Heypal::PlaceType.find_by_slug(type_name)
        filters << [place_type, count]
      end
    end
    filters
  end
end

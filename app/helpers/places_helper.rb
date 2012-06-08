module PlacesHelper

  # Amenities
  def amenities_group_1 
    [
      [t("places.amenities.kitchen"), :amenities_kitchen],
      [t("places.amenities.hot_water"), :amenities_hot_water], 
      [t("places.amenities.elevator"), :amenities_elevator],
      [t("places.amenities.parking_included"), :amenities_parking_included],
      [t("places.amenities.heating"), :amenities_heating],
      [t("places.amenities.handicap"), :amenities_handicap],
      [t("places.amenities.doorman"), :amenities_doorman],
      [t("places.amenities.aircon"), :amenities_aircon], 
      [t("places.amenities.buzzer_intercom"), :amenities_buzzer_intercom],
    ]
  end

  # Furnishings 
  def amenities_group_2
    [
      [t("places.amenities.internet"), :amenities_internet],
      [t("places.amenities.tv"), :amenities_tv],
      [t("places.amenities.dryer"), :amenities_dryer],    
      [t("places.amenities.internet_wifi"), :amenities_internet_wifi],
      [t("places.amenities.cable_tv"), :amenities_cable_tv],
      [t("places.amenities.washer"), :amenities_washer],
    ]
  end

  # Misc
  def amenities_group_3
    [
      [t("places.amenities.pets_allowed"), :amenities_pets_allowed],
      [t("places.amenities.breakfast"), :amenities_breakfast],
      [t("places.amenities.smoking_allowed"), :amenities_smoking_allowed],
      [t("places.amenities.suitable_events"), :amenities_suitable_events],
      [t("places.amenities.family_friendly"), :amenities_family_friendly],
    ]
  end

  def amenities_group_4
    [
      [t("places.amenities.gym"), :amenities_gym],
      [t("places.amenities.jacuzzi"), :amenities_jacuzzi],
      [t("places.amenities.hot_tub"), :amenities_hot_tub],
      [t("places.amenities.tennis"), :amenities_tennis],
      [t("places.amenities.pool"), :amenities_pool],
    ]
  end

  def place_size(place)
    html = ""
    unit = get_current_size_unit

    if unit  == "sqf" && place.size_sqf
      html << number_with_precision(place.size_sqf, :strip_insignificant_zeros => true, :precision => 1)
      html << t("units.square_feet_short")
    elsif unit == "sqm" && place.size_sqm
      html << number_with_precision(place.size_sqm, :strip_insignificant_zeros => true, :precision => 1)
      html << t("units.square_meters_short")
    end
    html
  end

  def place_price(place)
    "#{get_pref_currency}#{place.price_per_month}"
  end

  def render_photo(photo)
    p = photo.photo

    photo_title = photo.name.present? ? truncate(photo.name, :length => 23) : t("places.wizard.photos.no_caption")
    html = content_tag :div, :class => 'photo_image', :id => "image-#{photo.id}" do
      image_tag(p.url(:small), :data => {
        :id    => photo.id,
        :large => p.url(:large),
        :name  => photo.name || '',
        :trunc_name => truncate(photo.name, :length => 23) || ''
      }).html_safe
    end
    html << content_tag(:p, photo_title)

    html
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

  # to faken cons to still iterate and display for the last image the first and second image
  def carousel_photoset(place)
    hacked_photo_set = place.photos.all
    hacked_photo_set << place.photos[0] << place.photos[1]
  end

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

    city = City.find(place['city_id'])

    "/#{city.slug}/#{place['id']}-#{result}"
  end

  def seo_city_path(city)
    "/#{city.slug}"
  end

  def place_type_filters(place_type_counts)
    filters = []
    place_type_counts.each do |type_name, count|
      if count > 0
        place_type = PlaceType.find_by_slug(type_name)
        filters << [place_type, count]
      end
    end
    filters
  end

  def lenght_stay_type_options
    options_for_select([['week(s)', 'weeks'], ['month(s)', 'months']])
  end
end

#coding: utf-8
module LookupsHelper
  CURRENCIES = {'SGD' => 'SG$', 'USD' => 'US$', 'HKD' => 'HK$', 'GBP' => 'GB£', 'MYR' => 'RM', 'AUD' => 'A$'}
  LANGUAGES  = {'en' => 'English', 'es' => 'Spanish'}
  SIZE_UNITS = {'sqm' => I18n.t(:square_meters_short), 'sqf' => I18n.t(:square_feet_short)}
  CITIES     = [
    'Singapore',
    'Hong Kong',
    'Sydney, Australia',
    'Kuala Lumpur, Malaysia',
    'New York, United States',
    'San Francisco, United States',
    'Los Angeles, United States',
    'Shanghai, China',
    'Manila, Philippines'
  ]
  CANCELLATION_POLICIES = {1 => :flexible, 3 => :strict}

  def currencies
    CURRENCIES.keys
  end

  def currencies_select
    currencies
  end

  def currency_sign_of(currency)
    if CURRENCIES[currency]
      return CURRENCIES[currency]
    else
      return currency
    end
  end

  def city_name(id=0)
    CITIES[id-1]
  end

  def cancellation_policies_select
    CANCELLATION_POLICIES.collect { |key, value| [t(value), key] }
  end

  def cities_select
    [['Singapore',                    '1'],
     ['Hong Kong',                    '2'],
     ['Sydney, Australia',            '3'],
     ['Kuala Lumpur, Malaysia',       '4'],
     ['New York, United States',      '5'],
     ['San Francisco, United States', '6'],
     ['Los Angeles, United States',   '7'],
     ['Shanghai, China',              '8'],
     ['Manila, Philippines',          '9'],
     ['Beijing, China',               '10'],
     ['Jakarta, Indonesia',           '11'],
     ['Bangkok, Thailand',            '12'],
     ['Melbourne, Australia',         '13']
    ]
  end

  def place_types_select
    # id, translated name
    Heypal::Place.place_types.map {|p| [I18n.t(p['name'].parameterize('_').singularize), p['id']]}
  end

  def place_types_list
    # id, translated name, slug
    Heypal::Place.place_types.map {|p| [I18n.t(p['name'].parameterize('_').singularize), p['id'], p['name'].parameterize('_').singularize]}
  end

  def pref_language_list
    current = get_current_language
    select_tag :pref_language, options_for_select(LANGUAGES.map{ |l, t| [t, l]}, current), :class => "hide preference-entry", "data-current" => current
  end

  def pref_currency_list
    current = self.get_current_currency
    select_tag :pref_currency, options_for_select(CURRENCIES.map{ |c, t| [t, c]}, current), :class => "hide preference-entry", "data-current" => current
  end

  def pref_size_unit_list
    current = self.get_current_size_unit
    select_tag :pref_size_unit, options_for_select(SIZE_UNITS.map{ |c, t| [raw(t), c]}, current), :class => "hide preference-entry", "data-current" => current
  end

  def get_pref_language
    LANGUAGES[self.get_language] || 'English'
  end

  def get_pref_currency
    CURRENCIES[self.get_currency] || 'US$'
  end

  def get_pref_size_unit
    SIZE_UNITS[self.get_size_unit] || 'ft<sup>2</sup>'
  end

  def get_current_language
    get_language || 'en'
  end

  def get_current_currency
    get_currency || 'USD'
  end

  def get_currency_with_symbol(currency)
    case currency
    when "USD"
      symbol = "$"
    when "GBP"
      symbol = "£"
    when "SGD"
      symbol = "$"
    when "HKD"
      symbol = "$"
    else
      symbol = "$"
    end
    "#{symbol} #{currency}"
  end

  def get_current_size_unit
    get_size_unit || 'sqf'
  end

  def max_guest_options
    [["1 #{t(:guest)}", 1], ["3 #{t(:guests)}", 3], ["5 #{t(:guests)}", 5], ["10 #{t(:guests)}", 10]]
  end

  def sort_options
    [[t(:price_lowest), 'price_lowest'], [t(:price_highest), 'price_highest'], [t(:price_size_lowest), 'price_size_lowest'], [t(:price_size_highest), 'price_size_highest']]
  end

  def empty_place_type
    {"apartment"=>0, "house"=>0, "villa"=>0, "room"=>0, "other_space"=>0}
  end

  def cancellation_desc(place)
    t(LookupsHelper::CANCELLATION_POLICIES[place.cancellation_policy])
  end
  # Should be of this format:
  # {"date_end"=>[120]}
  def error_codes_to_messages(error_hash)
    ret = []
    error_hash.each do |field, error_codes|
      error_codes.each do |error_code|
        ret << "#{field.humanize}: #{t("errors.#{error_code}")}"
      end
    end

    ret
  end

  protected
  def get_language
    (current_user['pref_language'] if logged_in? && !current_user['pref_language'].blank?) || cookies[:pref_language] || nil
  end

  def get_currency
    (current_user['pref_currency'] if logged_in? && !current_user['pref_currency'].blank?) || cookies[:pref_currency] || nil
  end

  def get_size_unit
    (current_user['pref_size_unit'] if logged_in? && !current_user['pref_size_unit'].blank?) || cookies[:pref_size_unit] || nil
  end
end

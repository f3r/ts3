module LookupsHelper
  CURRENCIES = {'SGD' => 'SG$', 'USD' => 'US$', 'HKD' => 'HK$'}
  LANGUAGES = {'en' => 'English', 'da' => 'Danish'}
  SIZE_UNITS = {'sqm' => 'm<sup>2</sup>', 'sqf' => 'ft<sup>2</sup>'}

  CANCELLATION_POLICIES = {1 => :flexible, 2 => :moderate, 3 => :strict}

  def currencies
    CURRENCIES.keys
  end

  def currencies_select
    currencies
  end

  def currency_sign_of(country)
    CURRENCIES[country]
  end

  def cities

  end

  def cancellation_policies_select
    CANCELLATION_POLICIES.collect { |key, value| [t(value), key] }
  end 

  def cities_select
    [['Singapore', '1'], ['Hong Kong', '13984'], ['Kuala Lumpur', '4065']]
  end

  def place_types_select
    Heypal::Place.place_types.map {|p| [p['name'], p['id']]}
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

  def get_current_size_unit
    get_size_unit || 'sqf'
  end

  def max_guest_options
    [['1 Guest', 1], ['3 Guests', 3], ['5 Guests', 5], ['10 Guests', 10]]
  end

  def sort_options
    [['Price (Lowest First)', 'price_lowest'], ['Price (Highest First)', 'price_highest'], ['Price/Size (Lowest First)', 'price_size_lowest'], ['Price/Size (Highest First)', 'price_size_highest']]
  end

  def empty_place_type
    {"apartment"=>0, "house"=>0, "villa"=>0, "room"=>0, "other_space"=>0}
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

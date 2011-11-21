module LookupsHelper
  CURRENCIES = {'SGD' => '$', 'USD' => '$', 'HKD' => '$'}
  LANGUAGES = {'en' => 'English', 'da' => 'Danish'}

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

  def cities_select
    [['Singapore', '1'], ['Hong Kong', '13984'], ['Kuala Lumpur', '4065']]
  end

  def place_types_select
    Heypal::Place.place_types.map {|p| [p['name'], p['id']]}
  end

  def pref_language_list
    current = (self.get_language || 'en')
    select_tag :pref_language, options_for_select(LANGUAGES.map{ |l, t| [t, l]}, current), :class => "hide preference-entry", "data-current" => current
  end

  def pref_currency_list
    current = (self.get_currency || 'USD')
    select_tag :pref_currency, options_for_select(CURRENCIES.map{ |c, t| [t, c]}, current), :class => "hide preference-entry", "data-current" => current
  end

  def get_pref_language
    LANGUAGES[self.get_language] || 'English'
  end

  def get_pref_currency
    CURRENCIES[self.get_currency] || 'US$'
  end

  def current_currency
    get_currency
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
    (current_user['pref_language'] if logged_in?) || cookies[:pref_language] || nil
  end

  def get_currency
    (current_user['pref_currency'] if logged_in?) || cookies[:pref_currency] || nil
  end
end

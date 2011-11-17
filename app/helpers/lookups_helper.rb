module LookupsHelper
  CURRENCIES = {'SGD' => 'S$', 'USD' => 'US$', 'HKD' => 'HK$'}
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
    select_tag :pref_language, options_for_select(LANGUAGES.map{ |l, t| [t, l]}, (self.get_language || 'en')), :class => "hide preference-entry"
  end

  def pref_currency_list
    select_tag :pref_currency, options_for_select(CURRENCIES.map{ |c, t| [t, c]}, (self.get_currency || 'USD')), :class => "hide preference-entry"
  end

  def get_pref_language
    LANGUAGES[self.get_language] || 'English'
  end

  def get_pref_currency
    CURRENCIES[self.get_currency] || 'US$'
  end

  protected
  def get_language
    (current_user['pref_language'] if logged_in?) || cookies[:pref_language] || nil
  end

  def get_currency
    (current_user['pref_currency'] if logged_in?) || cookies[:pref_currency] || nil
  end
end

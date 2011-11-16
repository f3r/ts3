module LookupsHelper
  CURRENCIES = {'SGD' => 'S$', 'USD' => 'US$', 'HKD' => 'HK$'}

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
    #[["Apartment", 1], ["House", 2], ["Villa", 3], ["Room", 4], ["Shared Room", 5], ["Dorm", 6], ["Other space", 7]]    
    Heypal::Place.place_types.map {|p| [p['name'], p['id']]}    
  end

  def pref_language_list
    select_tag :pref_language, raw('<option value="en">English</option><option value="ph">Tagalog(lol)</option>'), :id => "pref-language-entry", :class => "hide"
  end

  def pref_currency_list
    select_tag :pref_currency, raw('<option value="USD">US$</option><option value="SGD">S$</option>'), :id => "pref-currency-entry", :class => "hide"
  end
end

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
    [["Apartment", 1], ["House", 2], ["Villa", 3], ["Room", 4], ["Shared Room", 5], ["Dorm", 6], ["Other space", 7]]    
  end

  def placeList
    Heypal::Place.placeList.map {|p| [p['name'], p['id']]}
  end

end

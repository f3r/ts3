module AvailabilitiesHelper
  def color_price(s, p) # self, place
    if !s['price_per_night']
      'red'
    elsif p['price_per_night'].nil? || s['price_per_night'] == p['price_per_night']
      'grey'
    elsif s['price_per_night'] > p['price_per_night']
      'blue'
    elsif s['price_per_night'] < p['price_per_night']
      'green'
    end
  end
  
  def date_formatted(d) # date
    ds = Date.parse(d)
    ds.strftime("%a %d/%B")
  end

  def price_availability(s, p) # self, place
    if s['availability_type'] == 1
      'unavailable / manual booking'
    else
      raw("New Price: #{s['price_per_night']} <small class='currency-sign'>#{currency_sign_of(p.currency)}</small> per night")
    end
  end
end

module AvailabilitiesHelper
  def color_price(s, p) # self, place
    if !s['price_per_night']
      'red'
    elsif s['price_per_night'] > p['price_per_night']
      'blue'
    elsif s['price_per_night'] < p['price_per_night']
      'green'
    else
      'grey'
    end
  end
  
  def date_formatted(d) # date
    ds = Date.parse(d)
    ds.strftime("%a %d/%B")
  end

  def price_availability(s) # self
    if s['availability_type'] == 1
      'unavailable / manual booking'
    else
      "New Price: #{s['price_per_night']} $ per night"
    end
  end
end

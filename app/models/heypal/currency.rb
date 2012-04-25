class Heypal::Currency < Heypal::Base

  attr_accessor :id, :currency_code, :symbol

  def self.all_active
    currencies = []
    result = request("/currencies.json?active=1", :get)
    if result['stat'] == 'ok'
      if result['currencies']
        currencies = result['currencies'].map{ |currency| self.new(currency["id"], currency["currency_code"], currency["symbol"])}
      end
    end
  end

  
  def initialize(id, currency_code, symbol)
  	@id = id
    @currency_code = currency_code
    @symbol = symbol
  end


end
class Heypal::Currency < Heypal::Base

  attr_accessor :id, :currency_code, :symbol , :currency_abbreviation

  def self.all
    @all ||= self.all_active
  end

  def self.all_active
    currencies = []
    result = request("/currencies.json?active=1", :get)
    if result['stat'] == 'ok'
      if result['currencies']
        currencies = result['currencies'].map{ |currency| self.new(currency["id"], currency["currency_code"], currency["symbol"], currency["currency_abbreviation"])}
      end
    end
  end

  
  def initialize(id, currency_code, symbol ,currency_abbreviation)
  	@id = id
    @currency_code = currency_code
    @symbol = symbol
    @currency_abbreviation = currency_abbreviation
  end


end
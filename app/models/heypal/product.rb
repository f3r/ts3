class Heypal::Product < Heypal::Base

  set_resource_path '/products.json'

  def location
    "#{self['location']['city']}, #{self['location']['country']}"
  end

  def rent?
    transaction['for_rent']
  end

  def sell?
    transaction['for_sell']    
  end

  def give?
    transaction['for_give']
  end

  def lend?
    transaction['for_lend']
  end

  def rent_price
    transaction['for_rent_price']    
  end

  def sell_price
    transaction['for_sell_price']    
  end

  def pickup?

  end

  def deliver?

  end

  def transaction
    self['Transaction']
  end

  def co2
    if self['co2'].present?
      "#{self['co2']} kg"
    end
  end

  def categories
    self['category_tree'].collect { |c| c['name'] }.join(" > ") 
  end

  # Magic methods. TODO: Make this better in the future
  def method_missing(sym, *args, &block)  
    if self.has_key?(sym)
      return self[sym.to_s]
    else
      super(sym, *args, &block)
    end
  end   

end

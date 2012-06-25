class Property <  ActiveRecord::Base
  if Product.table_exists?
    acts_as :product
  end

   def self.searcher
    Search::Service
  end

  def self.price_unit
    :sale
  end
end
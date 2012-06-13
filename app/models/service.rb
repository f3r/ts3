class Service < ActiveRecord::Base
  acts_as :product

  def self.searcher
  	Search::Service
  end

  def self.published
	self.where('products.published' => true)
  end
end
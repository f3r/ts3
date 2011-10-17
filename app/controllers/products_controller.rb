class ProductsController < ApplicationController

  def show
    @product = Heypal::Product.find('test', :resource_path => '/product.json')
  end

end

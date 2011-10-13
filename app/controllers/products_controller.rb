class ProductsController < ApplicationController

  def show
    @product = Heypal::Product.find('test')
  end

end

class Comments < ApplicationController
  before_filter :find_place

  def index
    
  end

  def show
    
  end

  def create
    
  end

  def reply_to_message
    
  end

  def delete
    
  end

  private

  def find_place
    @place = Heypal::Place.find(params[:id], current_token)
  end
end

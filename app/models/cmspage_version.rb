class CmspageVersion < ActiveRecord::Base
  belongs_to :page
  
  def display_name
    created_at
  end
end
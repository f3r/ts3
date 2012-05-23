class MenuSection < ActiveRecord::Base

  before_validation :make_name_lower_case

  validates_presence_of :name, :message => "Name can't be empty"
  validates_uniqueness_of :name, :message => "Name should be unique"
  has_and_belongs_to_many :cmspages, :conditions => "active = 1"
  
  
  private
    def make_name_lower_case
      name.downcase! unless name.blank?
    end
end
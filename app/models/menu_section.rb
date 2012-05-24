class MenuSection < ActiveRecord::Base

  before_validation :make_name_lower_case

  validates_presence_of :name, :message => "Name can't be empty"
  validates_uniqueness_of :name, :message => "Name should be unique"
  
  has_many :cmspage_menu_sections, :order => "position ASC"
  
  has_many :cmspages, :through => :cmspage_menu_sections, 
    :conditions => "active = 1",
    :include => :cmspage_menu_sections,
    :order => "position ASC"
  
  private
    def make_name_lower_case
      name.downcase! unless name.blank?
    end
end
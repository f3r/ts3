class MenuSection < ActiveRecord::Base

  before_validation :make_name_lower_case

  validates_presence_of :name, :message => "Name can't be empty"
  validates_uniqueness_of :name, :message => "Name should be unique"
  
  validates_inclusion_of :mtype, :in => [1,2], :message => "Invalid type"
  validates_inclusion_of :location, :in => [1,2], :message => "Invalid location"
  
  has_many :cmspage_menu_sections, :order => "position ASC"
  
  has_many :cmspages, :through => :cmspage_menu_sections, 
    :conditions => "active = 1",
    :include => :cmspage_menu_sections,
    :order => "position ASC"
    
  scope :left_menus, where(:location => 1)
  scope :right_menus, where(:location => 2)
  
  MENU_TYPES = {1 => "Inline", 2 => "DropDown"}
  MENU_LOCATIONS = {1 => "Left", 2 => "Right"}
  
  def menu_types
    MENU_TYPES
  end
  
  def menu_locations
    MENU_LOCATIONS
  end
  
  
  private
    def make_name_lower_case
      name.downcase! unless name.blank?
    end
end
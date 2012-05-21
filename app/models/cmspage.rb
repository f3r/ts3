class Cmspage < ActiveRecord::Base
  default_scope :order => 'id ASC'
   
  validates_presence_of   :page_title, :message => "101"
  validates_presence_of   :page_url, :message => "101"
  
  validates_uniqueness_of :page_url, :message => "Page Already exist with this name"
  validates_exclusion_of  :page_url, :in => proc {get_all_active_city_name} , :message => "Can't use this as page url (city name)"
  scope :active,    where("active")
  scope :inactive,  where("not active")
  
  def activate!
    self.active = true
    self.save
  end

  def deactivate!
    self.active = false
    self.save
  end
 
  # Get the content of the page
  def self.getPageContent(page)
    if page
      @pagecontents = Cmspage.where(:active => 1, :page_url => page).first
    end
  end
 
 def self.get_all_active_city_name
   @fields      = [:name]
   cityname  = []
   city_names = City.select(@fields).all
   city_names.each do |city_name|
     cityname << city_name["name"]
   end
   return cityname
 end

end
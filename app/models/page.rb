class Page < Cmspage

  has_many :cmspage_versions, :foreign_key => "cmspage_id", :order => "id DESC"
  
  before_update do |r|
    prev_description = r.description_was
    r.cmspage_versions.create({:content => prev_description})
  end
  
  def link
    "/#{self.page_url}"
  end

end
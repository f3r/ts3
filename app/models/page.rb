class Page < Cmspage

  def link
    "/#{self.page_url}"
  end

end
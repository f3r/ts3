module ApplicationHelper

  def placehold(width = 60, height = 60)
    raw "<img src='http://placehold.it/#{width}x#{height}' />"
  end

end

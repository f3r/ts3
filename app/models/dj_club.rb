class DjClub < ActiveRecord::Base
  has_attached_file :photo1, :styles => { :medium => "600x300>", :thumb => "100x100>" }
end
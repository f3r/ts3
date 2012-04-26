class Favorite < ActiveRecord::Base
  belongs_to :favorable
  belongs_to :user

  validates :user_id,        :presence => true, :uniqueness => {:scope => [:favorable_id, :favorable_type]}
  validates :favorable_id,   :presence => true, :uniqueness => {:scope => [:user_id, :favorable_type]}
  validates :favorable_type, :presence => true, :uniqueness => {:scope => [:favorable_id, :user_id]}

  def favorable=(a_record)
    self.favorable_id   = a_record.id
    self.favorable_type = 'Place'
  end
end
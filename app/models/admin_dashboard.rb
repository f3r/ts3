class AdminDashboard

  def self.conversion_funnel
    #As per https://www.pivotaltracker.com/story/show/29683383
    
    # 1. Registered user count
    User.consumer.count
    
    # 2. 
    User.consumer.where('last_sign_in_at >= ?', Time.now - 30.days).count
    
    # 3
    Comment.questions.count
    
    {}
  end

end
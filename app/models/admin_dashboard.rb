class AdminDashboard

  def self.user_funnel
    stats = {}
    
    # 1. Registered user count
    stats[:user_count] = {:label => "Registered Users", :value => User.consumer.count}
    
    # 2. users who have access the site in the last 30 days
    stats[:user_active_count] = {:label => "Users active in last 30 days", :value => User.consumer.where('last_sign_in_at >= ?', Time.now - 30.days).count}
    stats
  end
  
  def self.transaction_funnel
    stats = {}
    
    # 3 inquiries
    stats[:inquiry_count] = {:label => "Inquiries", :value => Inquiry.count}
    
    #4 transactions in 'initial' stage
    stats[:transaction_initial_state] = {:label => "Transaction Stage - Initial", :value => Transaction.where(:state => 'initial').count}
    
    #5 transactions in 'requested' stage
    stats[:transaction_requested_state] = {:label => "Transaction Stage - Requested", :value => Transaction.where(:state => 'requested').count}
    
    #6 transactions in 'ready_to_pay' stage
    stats[:transaction_ready_to_pay_state] = {:label => "Transaction Stage - Ready to Pay", :value => Transaction.where(:state => 'ready_to_pay').count}
    
    #7 transactions in 'ready_to_pay' stage
    stats[:transaction_paid_state] = {:label => "Transaction Stage - Paid", :value => Transaction.where(:state => 'paid').count}
    stats
  end
  
end
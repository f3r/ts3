class AdminDashboard

  def self.conversion_funnel
    
    stats = {}
    #As per https://www.pivotaltracker.com/story/show/29683383
    
    # 1. Registered user count
    stats[:user_count] = User.consumer.count
    
    # 2. users who have access the site in the last 30 days
    stats[:user_active_count] = User.consumer.where('last_sign_in_at >= ?', Time.now - 30.days).count 
    
    # 3 inquiries
    stats[:inquiry_count] = Inquiry.count
    
    #4 transactions in 'initial' stage
    stats[:transaction_initial_state] = Transaction.where(:state => 'initial').count
    
    #5 transactions in 'requested' stage
    stats[:transaction_requested_state] = Transaction.where(:state => 'requested').count
    
    #6 transactions in 'ready_to_pay' stage
    stats[:transaction_ready_to_pay_state] = Transaction.where(:state => 'ready_to_pay').count
    
    #7 transactions in 'ready_to_pay' stage
    stats[:transaction_paid_state] = Transaction.where(:state => 'paid').count
    
    
    stats
  end
  
  def self.conversion_funnel_as_g_chart_params
    funnel_items = self.conversion_funnel
    
    item_labels = {}
    
    item_labels[:user_count] = "Registered Users"
    item_labels[:user_active_count] = "Users active in last 30 days"
    item_labels[:inquiry_count] = "Inquiries"
    item_labels[:transaction_initial_state] = "Transaction Stage - Initial"
    item_labels[:transaction_requested_state] = "Transaction Stage - Requested"
    item_labels[:transaction_ready_to_pay_state] = "Transaction Stage - Ready to Pay"
    item_labels[:transaction_paid_state] = "Transaction Stage - Paid"

    
    g_p =[]
    g_p << "bhs".to_query("cht")
    g_p << "ffffff,FF9900".to_query("chco")
    g_p << "x,x,y".to_query("chxt")
    
    chxl = "1:||2:|"
    
    funnel_keys = []
    
    axis1 = []
    
    for funnel_item_key in funnel_items.keys.reverse
      funnel_keys << item_labels[funnel_item_key]
      axis1 << funnel_items[funnel_item_key]
    end
    
    max_val = funnel_items.values.max
    
    axis1 = axis1.reverse
    
    axis2 = []
    
    for v in axis1
      axis2 << (max_val - v) / 2
    end
    
    chxl << funnel_keys.join("|") << "|"
    
    g_p << chxl.to_query("chxl")
    
    chxp = "1,50|3,50"
    
    g_p << chxp.to_query("chxp")
    
    chd = "t:#{axis2.join(',')}|#{axis1.join(',')}"
    
    g_p << chd.to_query("chd")
    
    g_p << "a".to_query("chbh")
    
    g_p << "800x200".to_query("chs")
    
    g_p << "a".to_query("chds")
    
    g_p << "chm=N**,000000,1,-1,11,,c"
    
    g_p.join("&")
    
  end
end
class AdminDashboard

  def self.user_funnel
    stats = {}
    stats[:user_count] = {:label => "Registered Users", :value => User.consumer.count}
    stats[:user_active_count] = {:label => "Users active in last 30 days", :value => User.consumer.where('last_sign_in_at >= ?', Time.now - 30.days).count}
    stats
  end

  def self.transaction_funnel
    stats = {}
    stats[:inquiry_count] = {:label => "Inquiries", :value => Inquiry.count}
    stats[:transaction_initial_state] = {:label => "Transaction Stage - Initial", :value => Transaction.where(:state => 'initial').count}
    stats[:transaction_requested_state] = {:label => "Transaction Stage - Requested", :value => Transaction.where(:state => 'requested').count}
    stats[:transaction_ready_to_pay_state] = {:label => "Transaction Stage - Ready to Pay", :value => Transaction.where(:state => 'ready_to_pay').count}
    stats[:transaction_paid_state] = {:label => "Transaction Stage - Paid", :value => Transaction.where(:state => 'paid').count}
    stats
  end


  def self.agent_funnel
    stats = {}
    stats[:agent] = {:label => "Agents", :value => User.agent.count}
    stats[:agent_with_listing] = {:label => "Own listing", :value => Product.count(:user_id, :distinct => true)}
    stats[:agent_with_published_listing] = {:label => "Published listing", :value => Product.published.count(:user_id, :distinct => true)}
    stats
  end
end
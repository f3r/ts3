require 'securerandom'
class Alert < ActiveRecord::Base
  
  validates_presence_of [:user_id, :schedule], :message => "101"
  validates_inclusion_of :delivery_method, :in => ["email", "sms", "email_sms"], :message => "103"
  validates_inclusion_of :schedule, :in => ["daily", "weekly", "monthly"], :message => "103"
  
  before_create :set_search_code, :set_delivered_at, :set_alert_type

  belongs_to :user
  serialize :query
  serialize :results
  
  belongs_to :search, :class_name => SiteConfig.product_class.searcher.name
  
  accepts_nested_attributes_for :search
  
  default_scope where(:deleted_at => nil, :alert_type => SiteConfig.product_name)
  
  def self.send_alerts
    alerts = Alert.find_by_sql(["
      SELECT * from alerts 
      WHERE ((schedule = ? AND delivered_at < ?) OR (schedule = ? AND delivered_at < ?) OR (schedule = ? AND delivered_at < ?)) AND active = ?",
      "daily", Time.now - 1.day,
      "weekly", Time.now - 1.week,
      "monthly", Time.now - 1.month,
      true
    ])
      
    #TODO Add logic to send the alert mails      
  end
  
  # keeps alerts for a while, avoids breaking links sent through email
  def soft_delete
    ActiveRecord::Base.record_timestamps = false
    self.deleted_at = Time.now
    self.save
    ActiveRecord::Base.record_timestamps = true
  end
  
  def search_params
    #don't touch the original
    params = {}
    query_new = self.query.dup
    city_slug = City.find(query_new['city_id']).slug
    params['city'] = city_slug
    query_new.each do |k, v|
      params = params.merge({"search[#{k}]" => v})
    end
    params
  end
  
  
  private    
    def set_search_code
      self.search_code = generate_search_code
    end
    
    def set_alert_type
      self.alert_type = SiteConfig.product_name.capitalize
    end
    
    # used for short url
    def generate_search_code
      search_code = Time.now.strftime("%y%m%d#{SecureRandom.urlsafe_base64(4).upcase}")
      search = Alert.find_by_search_code(search_code)
      if search
        self.generate_search_code
      else
        search_code
      end
    end
    
    # set initial delivery day as today.
    def set_delivered_at
      self.delivered_at = Date.today
    end
    
    def valid_alert?
      #TODO Check if the alert is still valid
    end
  
end
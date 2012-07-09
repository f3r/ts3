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
      WHERE ((schedule = ? AND delivered_at < ?) OR (schedule = ? AND delivered_at < ?) OR (schedule = ? AND delivered_at < ?)) AND active and alert_type = ?",
      "daily", Time.now - 1.day,
      "weekly", Time.now - 1.week,
      "monthly", Time.now - 1.month,
      SiteConfig.product_name.capitalize
    ])
    
    if !alerts.blank?
        for alert in alerts
          if alert.valid_alert?
            #TODO: REFINE REFINE
            new_results = []
            recently_added = []
            if alert.search.count > 0
              city = City.find(alert.search.city_id)
              mailer = AlertMailer.send_alert(alert.user, alert, city, new_results, recently_added)
              if mailer.deliver
                alert.update_delivered(new_results) #if new_results
              end
            end
          end
        end
    end
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
  
  def valid_alert?
    #TODO Check if the alert is still valid
    true
  end  
  
  def update_delivered(new_results)
    new_results_ids = new_results.map{|x| x[:id]}
    results_ids = (self.results + new_results_ids).uniq
    ActiveRecord::Base.record_timestamps = false
    self.update_attributes({:delivered_at => Date.today, :results => results_ids})
    ActiveRecord::Base.record_timestamps = true
  end
  
  
  def get_results(opts = {})
    search = self.search
    resource_class = search.resource_class
    if opts[:search_type] == "new_results"
      exclude_ids = self.results
      if exclude_ids.present?
        search.add_sql_condition(["#{resource_class.table_name}.id not in (?)", exclude_ids])
      end
    end
    get_full_results(search)
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
    
    def get_full_results(search)
      search = search.detach
      results = []
      results += search.results.all.to_a
      for page in (2..search.total_pages)
        search = search.detach
        search.current_page = page
        results += search.results.all.to_a
      end
      results
    end
  
end
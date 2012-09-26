class Db < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "tse_admin_faq_#{Rails.env}".to_sym
end

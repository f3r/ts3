module InquiriesHelper
  # 
  # def payment_url(inquiry)
  #   values = {
  #     :business => "nico_1334303615_biz@heypal.com",
  #     :cmd => "_xclick",
  #     :upload => 1,
  #     :return => 'http://squarestays.dev',
  #     :invoice => inquiry['id'],
  #     :notify_url => 'http://localhost:3000/paypal_callback',
  #     :amount => '300',
  #     :item_name => 'Rental Request Fee',
  #     :item_number => inquiry['id']
  #   }
  #   "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.map { |k,v| "#{k}=#{v}"  }.join("&")
  # end
  def transaction_length_options
    opts = SiteConfig.transaction_length_options
    options_for_select(opts, current_price_unit.to_s.gsub("per_", "").pluralize)
  end

  def show_inquiry_length_fields?
    opts = SiteConfig.transaction_length_options
    opts.any?
  end

  def payment_notification_url(inquiry)
    paypal_callback_url
  end

  def save_inquiry_params(inquiry)
    session[:inq] = inquiry.attributes.select{ |k| k.in? ['check_in', 'guests', 'check_out', 'length_stay', 'length_stay_type'] }.merge({"message" => @inquiry.message})
  end

  def saved_inquiry_params?
    session[:inq].present?
  end

  def saved_inquiry_params
    session[:inq]
  end

  def clear_saved_inquiry_params
    session[:inq] = nil
  end
end
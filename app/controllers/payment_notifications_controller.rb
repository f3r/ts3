class PaymentNotificationsController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    # You maybe want to log this notification
    notify = ActiveMerchant::Billing::Integrations::Paypal::Notification.new request.raw_post
    transaction_code = notify.item_id

    if notify.acknowledge && notify.complete?
      @result = Heypal::Transaction.pay(transaction_code, :amount => params[:mc_gross])
    end

    render :nothing => true
  end
end

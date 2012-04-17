require 'spec_helper'

describe PaymentNotificationsController do
  it "processes ipn request" do
    ActiveMerchant::Billing::Integrations::Paypal::Notification.stub(:new => stub(:item_id => 'abc', :acknowledge => true, :complete? => true))
    Heypal::Transaction.should_receive(:pay)
    post :create, :item_id => 'abc'
    response.should be_success
  end
end

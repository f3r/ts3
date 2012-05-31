require 'spec_helper'

describe PaymentNotificationsController do
  it "processes ipn request" do
    @inquiry = create(:inquiry)
    @transaction = @inquiry.transaction
    @transaction.update_attribute(:state, 'ready_to_pay')
    id = @transaction.transaction_code

    ActiveMerchant::Billing::Integrations::Paypal::Notification.stub(:new => stub(:item_number => id, :item_id => id, :acknowledge => true, :complete? => true))

    post :create, :item_number => 'abc', :mc_gross => "300.00"
    response.should be_success
  end
end

if Rails.env.production?
  PAYPAL_ACCOUNT = 'sales@heypal.com'
else
  PAYPAL_ACCOUNT = 'nico_1334303615_biz@heypal.com'
  ActiveMerchant::Billing::Base.mode = :test
end

require 'active_merchant/billing/integrations/action_view_helper'

ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)
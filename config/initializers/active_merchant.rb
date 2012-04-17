ActiveMerchant::Billing::Base.mode = PAYPAL_MODE.to_sym
require 'active_merchant/billing/integrations/action_view_helper'

ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)
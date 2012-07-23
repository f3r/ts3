class Payment < ActiveRecord::Base
  include Workflow
  belongs_to :recipient, :class_name => 'User'
  belongs_to :transaction

  has_many :payment_logs, :dependent => :destroy

  workflow_column :state

  workflow do
    state :ready do
      event :pay, :transitions_to => :paid
      event :fail, :transitions_to => :failed
    end
    state :paid
    state :failed

    after_transition do |from, to, triggering_event, *event_args|
      log_payment(:from => from, :to => to, :triggering_event => triggering_event, :additional_data => event_args[0])
    end
  end

  def do_payment
    gateway = self.class.init_paypal_gateway
    #TODO: Formulate the correct subject and note - Need discussion
    response = gateway.transfer(self.amount, self.recipient.email,
                                :subject => "Remaining amount", :note => self.note)
    if response.success?
      self.pay!(response)
    else
      self.fail!(response)
    end
  end

  # This is master trigger method
  # Iterates over the pending payments
  def self.send_payments
    payments = self.pending
    payments.each do |payment|
      payment.do_payment
    end
  end

  def self.init_paypal_gateway
    @paypal_gateway ||= ActiveMerchant::Billing::PaypalGateway.new({
                                                                     :login => PAYPAL_API_USERNAME,
                                                                     :password => PAYPAL_API_PASS,
                                                                     :signature => PAYPAL_API_SIGN
    })
  end

  private

  def self.pending(duration = 48.hours)
    #Get the Payments with state = :ready and has the transaction state :paid
    payments = self.joins(:transaction => :inquiry).where('payments.state = ?', :ready)
    .where('transactions.state = ?', :paid)
    .where('inquiries.check_out <= ?', Time.now - duration)
  end

  def log_payment(options={})
    log = self.payment_logs.create(
      :state => options[:to],
      :previous_state => options[:from],
      :additional_data => options[:additional_data]
    )
    log.save
  end

end

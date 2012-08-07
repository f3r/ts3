class PreviewMails < MailView

  ###############################################################
  # REGISTRATION_MAILER
  ###############################################################
  def welcome_instructions
    user = getUser()
    RegistrationMailer.welcome_instructions(user)
  end

  def reset_password
    user = getUser()
    RegistrationMailer.reset_password_instructions(user)
  end

  def new_question
    user = getUser()
    question = getComment()
    UserMailer.new_question(user, question)
  end

  def new_question_reply
    question = getComment()
    user = question.user
    UserMailer.new_question_reply(user, question)
  end

  # def confirmation_instructions
  #   user = User.first
  #   RegistrationMailer.confirmation_instructions(user)
  # end

  ###############################################################
  # USER_MAILER
  ###############################################################
  def auto_welcome
    user = getUser()
    UserMailer.auto_welcome(user)
  end

  def new_message_reply
    user = getUser()
    UserMailer.new_message_reply(user, Message.where(['system is null']).first)
  end

  ###############################################################
  # INQUIRY_MAILER
  ###############################################################
  def inquiry_confirmed_renter
    InquiryMailer.inquiry_confirmed_renter(an_inquiry)
  end

  def inquiry_confirmed_owner
    InquiryMailer.inquiry_confirmed_owner(an_inquiry)
  end

  def inquiry_reminder_owner
    InquiryMailer.inquiry_reminder_owner(an_inquiry)
  end

  ###############################################################
  # TRANSACTION_MAILER
  ###############################################################
  def transaction_request_renter
    TransactionMailer.request_renter(an_inquiry)
  end

  def transaction_request_owner
    TransactionMailer.request_owner(an_inquiry)
  end

  def transaction_approve_renter
    TransactionMailer.approve_renter(an_inquiry)
  end

  def transaction_approve_owner
    TransactionMailer.approve_owner(an_inquiry)
  end

  def transaction_pay_renter
    TransactionMailer.pay_renter(an_inquiry)
  end

  def transaction_pay_owner
    TransactionMailer.pay_owner(an_inquiry)
  end
  
  def search_alert
    alert = Alert.last
    user = getUser()
    alert.search = getSearch()
    
    city = City.find(alert.search.city_id)
    new_results = alert.search.resource_class.limit(2).all
    recently_added = alert.search.resource_class.limit(2).offset(2).all
    AlertMailer.send_alert(user, alert, city, new_results, recently_added)
  end

  private

  def an_inquiry
    inquiry = Inquiry.new(
      :created_at => 2.days.ago,
      :product => getProduct(),
      :user => getUser(),
      :check_in => 1.month.from_now.to_date,
      :length_stay => 1,
      :length_stay_type => 'months',
      :extra => {
        :name => 'Consumer',
        :email => 'consumer@email.com'
      }
    )
  end
  
  def getUser
    user = User.new(
      :id => 9999,
      :email => "preview@heypal.com",
      :first_name => "Heypal",
      :last_name => "SE",
      :birthdate  => Date.current - 20.year ,
      :password => "heypal_preview",
      :password_confirmation => "heypal_preview",
      :confirmed_at  => 1.day.ago ,
      :role => "user")
  end
  
  def getComment
    comment = Comment.new(
      :user => getUser(),
      :comment => "Mail preview comments",
      :product_id => getProduct())
  end
  
  def getSearch
    search = Property.searcher.new({:id => 9999, :city_id => City.active.first})
  end
  
  def getProduct
    product = Product.new(
      :user => getUser(),
      :title => "Mail preview title",
      :description =>"Mail preview description",
      :address_1   => "Heypal",
      :address_2  => "Search engine",
      :zip  => "123456",
      :currency => Currency.active.first,
      :city => City.active.first,
      :price_per_month => 1000)
  end
  
end
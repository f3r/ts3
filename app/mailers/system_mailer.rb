class SystemMailer < BaseMailer
  default :to => SiteConfig.support_email
  default :bcc  => SiteConfig.mail_bcc

  # ==Description
  # Email sent when the user sends feedback
  def user_feedback(user, type, message)
    @user = user
    @type = type
    @message = message

    mail(:subject => "User Feedback (#{type})")
  end

  def user_contact(contact)
    @contact = contact
    mail(:subject => "Contact request from (#{@contact[:name]})")
  end

  def time_to_pay
  end
end
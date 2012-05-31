class SystemMailer < BaseMailer
  default :to => SiteConfig.mail_bcc

  # ==Description
  # Email sent when the user sends feedback
  def user_feedback(user, type, message)
    @user = user
    @type = type
    @message = message

    mail(:subject => "User Feedback (#{type})")
  end
end
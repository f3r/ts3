class PreviewMails < MailView

  ###############################################################
  # REGISTRATION_MAILER
  ###############################################################
  def welcome_instructions
    user = User.first
    RegistrationMailer.welcome_instructions(user)
  end

  def reset_password
    user = User.first
    RegistrationMailer.reset_password_instructions(user)
  end
end
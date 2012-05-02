class RegistrationMailer < Devise::Mailer
  layout 'user_email'
  helper 'application'

  default :from => MAILER_SENDER
  default :bcc  => ["jeremy@squarestays.com", "fer@squarestays.com"].join(',')

  def welcome_instructions(user)
    @user      = user
    recipients = "#{user.full_name} <#{user.email}>"
    subject    = 'Welcome to SquareStays'

    mail(:to => recipients, :subject => subject)
  end
end
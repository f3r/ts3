class BaseMailer < ActionMailer::Base
  layout 'user_email'

  default :from => MAILER_SENDER
  default :bcc  => ["jeremy@squarestays.com", "fer@squarestays.com"].join(',')
end
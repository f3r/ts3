class BaseMailer < ActionMailer::Base
  layout 'user_email'

  default :from => SiteConfig.mailer_sender
  default :bcc  => SiteConfig.mail_bcc
end
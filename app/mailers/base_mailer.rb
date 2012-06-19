class BaseMailer < ActionMailer::Base
  layout 'user_email'
  helper :application
  default :from => SiteConfig.mailer_sender
  default :bcc  => SiteConfig.mail_bcc
end
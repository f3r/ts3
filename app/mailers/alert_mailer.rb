class AlertMailer < BaseMailer

  # ==Description
  # Email alert for search results
  def send_alert(user, alert, city, new_results, recently_added)
    @alert          = alert
    @user           = user
    @city           = city
    @new_results    = new_results
    @recently_added = recently_added
    
    recipients = "#{user.full_name} <#{user.email}>"
    subject    = "Your #{SiteConfig.product_name.downcase.pluralize} search alert"

    mail(:to => recipients, :subject => subject)
  end

end
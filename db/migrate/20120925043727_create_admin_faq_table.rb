class CreateAdminFaqTable < ActiveRecord::Migration
  def connection
    ActiveRecord::Base.establish_connection("tse_admin_faq_#{Rails.env}".to_sym).connection
  end

  def change
    create_table :faqs do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
    
    faq1 = Faq.create(:title => "How to configure Facebook App in our Application?",
          :content => "        1. Login to https://developers.facebook.com
      2. Go to Tools Page by clicking the Tools menu in the top bar.
      3. Click 'App Dashboard' in the left sidebar or  'App Dashboard' link under 'Creating, managing and testing your App' area.
      4. It leads you to Facebook App development page.
      5. Click 'Create new App' button in top right.
      6. 'Create New App' popup will appear, enter a valid App Name( this one should be your Display name) and continue.
      7. A 'Security Check Required' box will appear, enter the given captcha in the text field and submit.
      8. Now you are in App's Basic settings page.
      9. Enter your domain address in 'App Domains' area.
      10. Enter the category and sub category things, it's an optional one.
      11. Check the 'Website with Facebook Login' link and enter you site url there( if your application supports Facebook login).
      12. Copy your 'App ID' and 'App Secret' from the top.
      13. Save your changes.
      14. Login to application's admin console.
      15. Go to settings/config menu.
      16. Paste the Facebook App ID and Secret in the desired fields in the 'Credentials for external services' area.
      17. Save your changes.")
            
    faq2 = Faq.create(:title => "How to configure Twitter App in our Application ?",
          :content => "        1. Login to https://dev.twitter.com
      2. Click 'Create an app' and this leads you to the app settings page .
      3. Enter your application name, description, website and callback url, agree the terms and conditions, enter captacha text and click 'Create your Twitter Application'.
      4. Now you are in your twitter app settings page.
      5. Click 'create my access token' button in the details tab.
      6. Go to settings tab.
      7. Select your application icon.
      8. Change Application Type access, now it's in read access, change that to 'Read, Write and Access direct messages'.
      9. Save your changes by clicking 'Update this Twitter Applications Settings'.
      10. Go to OAuth tool tab and copy the Consumer key and Consumer secret.
      11. Login to application's admin console.
      12. Go to settings/config menu.
      13. Paste 'Consumer key' to 'Twitter App Id' and 'Consumer secret' to 'Twitter Secret' in the 'Credentials for external services' area.
      14. Save your changes.");

    ActiveRecord::Base.establish_connection("#{Rails.env}").connection
  end
end

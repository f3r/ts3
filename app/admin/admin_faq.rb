ActiveAdmin.register_page "Admin Faq" do
  menu :label => "Help", :title => "FAQ", :priority => 11
  content do
    div :class => "info", :id => "admin_faq" do
      div :class => "intro span16" do
        h3 "Frequently Asked Questions"
        para "This FAQ section helps Site Administrator's to configure site settings."
      end
      div :class => "span16" do
        div :id => "facebook_faq"
        div :class => "well expandable collapsed", :style => "width:865px;" do
          h4 "1. How to configure Facebook App in our Application?"
          a "read more", "#",:class => "read-more",:style => "display: block;"
          div :class => "inner" do
            para "1. Login to https://developers.facebook.com"
            para "2. Go to Tools Page by clicking the Tools menu in the top bar."
            para "3. Click 'App Dashboard' in the left sidebar or  'App Dashboard' link under 'Creating, managing and testing your App' area."
            para "4. It leads you to Facebook App development page."
            para "5. Click 'Create new App' button in top right."
            para "6. 'Create New App' popup will appear, enter a valid App Name( this one should be your Display name) and continue."
            para "7. A 'Security Check Required' box will appear, enter the given captcha in the text field and submit."
            para "8. Now you are in App's Basic settings page."
            para "9. Enter your domain address in 'App Domains' area."
            para "10. Enter the category and sub category things, it's an optional one."
            para "11. Check the 'Website with Facebook Login' link and enter you site url there( if your application supports Facebook login)"
            para "12. Copy your 'App ID' and 'App Secret' from the top."
            para "13. Save your changes."
            para "14. Login to application's admin console."
            para "15. Go to settings/config menu."
            para "16. Paste the Facebook App ID and Secret in the desired fields in the 'Credentials for external services' area."
            para "17. Save your changes."
          end
        end
        div :id => "twitter_faq"
        div :class => "well expandable collapsed", :style => "width:865px;" do
          h4 "2. How to configure Twitter App in our Application ?"
          a "read more", "#",:class => "read-more",:style => "display: block;"
          div :class => "inner" do
            para "1. Login to https://dev.twitter.com"
            para "2. Click 'Create an app' and this leads you to the app settings page ."
            para "3. Enter your application name, description, website and callback url, agree the terms and conditions, enter captacha text and click 'Create your Twitter Application'."
            para "4. Now you are in your twitter app settings page."
            para "5. Click 'create my access token' button in the details tab"
            para "6. Go to settings tab."
            para "7. Select your application icon."
            para "8. Change Application Type access, now it's in read access, change that to 'Read, Write and Access direct messages'."
            para "9. Save your changes by clicking 'Update this Twitter Applications Settings'."
            para "10. Go to OAuth tool tab and copy the Consumer key and Consumer secret."
            para "11. Login to application's admin console."
            para "12. Go to settings/config menu."
            para "13. Paste 'Consumer key' to 'Twitter App Id' and 'Consumer secret' to 'Twitter Secret' in the 'Credentials for external services' area."
            para "14. Save your changes."
          end
        end
     end
    end
  end
end
  
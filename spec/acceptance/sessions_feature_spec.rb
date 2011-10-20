require 'acceptance/acceptance_helper'

feature 'Sessions feature', %q{
  As a user
  I should be able to ...
} do

  scenario 'signin using my email and password' do
    visit '/login'

    page.should have_content(t(:login))

    fill_in 'email', :with => 'test@email.com'
    fill_in 'password', :with => 'password123'

    click_button 'Login'

    page.should have_content(t(:dashboard))
    page.should have_content(t(:sign_out))
  end

  scenario 'signout' do
    visit '/logout'

    page.should have_content(t(:sign_in))
  end
end

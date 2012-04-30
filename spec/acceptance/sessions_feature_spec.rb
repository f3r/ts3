require 'acceptance/acceptance_helper'

feature 'Sessions feature', %q{
  As a user
  I should be able to login
} do

  background do
    @user = Factory(:user)
  end

  scenario 'sign in using my email and password' do
    visit '/login'

    page.should have_content(t(:login))

    fill_in 'email', :with => @user.email
    fill_in 'password', :with => @user.password

    click_button 'Login'
    debugger
    page.should have_content(t(:sign_out))
  end

  scenario 'signout' do
    visit '/logout'

    page.should have_content(t(:sign_in))
  end
end

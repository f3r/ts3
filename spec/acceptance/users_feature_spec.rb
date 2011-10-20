require 'acceptance/acceptance_helper'

feature 'Users feature', %q{
  In order to create a user
  As a user
  I want ...
} do

  scenario 'signup' do

    visit '/signup'

    page.should have_content(I18n.translate(:create_new_account))

    fill_in 'user[name]', :with => 'Test'
    fill_in 'user[email]', :with => 'test@email.com'

    fill_in 'user[password]', :with => 'password123'
    fill_in 'user[password_confirmation]', :with => 'password123'

    click_button 'Create account'

    #page.current_url.should == 'dashboard'
  end

  scenario 'signup using my facebook account' do
    pending
  end

  scenario 'confirm my account' do
    Heypal::User.stub!(:confirm).and_return(true)

    visit '/users/confirm?confirmation-token=somevalidconfirmationcode'

    page.should have_content(I18n.translate(:user_confirmed))

  end

  scenario 'confirm my account with an invalid confirmation code' do
    Heypal::User.stub!(:confirm).and_return(false)

    visit '/users/confirm?confirmation-token=someinvalidconfirmationcode'

    page.should have_content(t(:invalid_confirmation_code))
  end

  scenario 'resend my confirmation code' do

    visit '/users/confirm'

    page.should have_content(t(:resend_confirmation))

    Heypal::User.stub!(:resend_confirmation).and_return(true)

    page.status_code.should == 200
  end


  scenario 'reset my password' do

    visit '/users/reset_password'

    page.should have_content(t(:reset_password))

    Heypal::User.stub!(:reset_password).and_return(true)


    page.status_code.should == 200
  end

  scenario 'confirm my reset password' do
    pending
  end 


end

require 'acceptance/acceptance_helper'

feature 'StaticPages feature', %q{
  As a user
  I should be able to 
} do

  background do
    @page = FactoryGirl.create(:cmspage)
  end

  scenario 'visit a StaticPage' do
    visit "/#{@page.page_url}"
    page.should have_content(@page.description)
  end

  scenario 'see a 404 if the StaticPage doesnt exist' do
    pending
  end
end
# require 'acceptance/acceptance_helper'

# feature '[StaticPages]', %q{As a user ISBAT} do

#   background do
#     @page = FactoryGirl.create(:cmspage)
#     FactoryGirl.create(:currency)
#   end

#   scenario 'visit a StaticPage' do
#     visit "/#{@page.page_url}"
#     @page.description.each do |paragraph|
#       page.should have_content(paragraph)
#     end
#   end

#   scenario 'see a 404 if the StaticPage doesnt exist' do
#     visit "/#{@page.page_url}_non-existant-URL"
#     page.status_code.should == 404
#   end
# end

describe "StaticPages" do
  it "renders 404" do
    # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
    get '/sjksjksjks'
    response.status.should be(404)
  end
end
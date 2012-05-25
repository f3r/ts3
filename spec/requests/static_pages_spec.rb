require 'spec_helper'

describe "StaticPages" do
  before(:each) do
    @page = FactoryGirl.create(:cmspage)
    FactoryGirl.create(:currency)
  end

  it "renders static page" do
    get "/#{@page.page_url}"
    response.body.should include (@page.description)
    # @page.description.each do |paragraph|
    #   response.body.should include(paragraph)
    # end
  end

  it "renders 404" do
    lambda {
      get '/sjksjksjks'
    }.should raise_error(ActiveRecord::RecordNotFound)
  end
end
require 'spec_helper'

describe "Menu" do
  before(:each) do
    create(:city, :name => "Singapore")
    create(:currency)
  end

  def login_as(user)
    visit '/users/login'
    fill_in 'user[email]',    :with => @agent.email
    fill_in 'user[password]', :with => @agent.password
    click_button 'Login'
  end

  context "Edit or New listing link" do
    before(:each) do
      @agent = create(:agent)
      login_as @agent
    end

    context "Service" do
      before(:each) do
        SiteConfig.stub(:product_class).and_return(Service)
      end
      
      it "shows new" do
        visit "/"
        find(:xpath,"/html/body/header/div[2]/div/div/div/div/ul[2]/li/a")[:href].should == "/listings/new"
      end

      it "shows edit" do
        service = create(:service, :user => @agent)
        visit "/"
        find(:xpath,"/html/body/header/div[2]/div/div/div/div/ul[2]/li/a")[:href].should == "/listings/#{service.id}/edit"
      end
      
    end

    context "Property" do
      before(:each) do
        SiteConfig.stub(:product_class).and_return(Property)
      end
      
      it "shows new" do
        visit "/"
        find(:xpath,"/html/body/header/div[2]/div/div/div/div/ul[2]/li/a")[:href].should == "/listings/new"
      end

      it "shows new again" do
        service = create(:property, :user => @agent)
        visit "/"
        find(:xpath,"/html/body/header/div[2]/div/div/div/div/ul[2]/li/a")[:href].should == "/listings/new"
      end
      
    end
    
  end
  
end

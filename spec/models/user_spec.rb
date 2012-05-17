require 'spec_helper'

describe User do
  context "name=" do
    it "parses the first name and last name" do
      user = User.new

      user.name = "Diego Maradona"
      user.first_name.should == "Diego"
      user.last_name.should == "Maradona"

      user.name = "Diego Armando Maradona"
      user.first_name.should == "Diego"
      user.last_name.should == "Armando Maradona"

      user.name = "Diego"
      user.first_name.should == "Diego"
      user.last_name.should be_nil
    end
  end

  context "Preferences" do
    let(:user){ FactoryGirl.create(:user) }

    it "stores prefered city" do
      city = FactoryGirl.create(:city)
      user.change_preference(:pref_city, city.id)
      user.reload
      user.prefered_city.should == city
    end

    it "stores prefered currency"

    it "stores prefered language" do
      user.change_preference(:pref_language, 'pt')
      user.reload
      user.pref_language.should == 'pt'
    end
  end

  context "OAuth" do
    let(:user){ FactoryGirl.create(:user) }

    before(:each) do
      @token = Hashie::Mash.new({'uid' => '1234',
        "provider" => "facebook",
        "credentials" => {
          "token" => "token123",
          "secret" => "secret123",
        },
        "info" => {
          "email" => 'user@facebook.com',
          "first_name" => 'John',
          "last_name" => 'Smith'
        }
      })
    end

    it "stores facebook authentication" do
      user.apply_oauth(@token)
      user.authentications.size.should == 1
      auth = user.authentications.first

      auth.provider.should == 'facebook'
      auth.uid.should == '1234'
      auth.token.should == "token123"
      auth.secret.should == "secret123"
    end

    it "updates facebook authentication" do
      user.apply_oauth(@token)
      @token.credentials.token = "token456"
      user.apply_oauth(@token)
      auth = user.authentications.first

      auth.provider.should == 'facebook'
      auth.uid.should == '1234'
      auth.token.should == "token456"
      auth.secret.should == "secret123"
    end

    it "creates a user from facebook authentication" do
      new_user = User.from_oauth(@token)
      new_user.first_name.should == 'John'
      new_user.last_name.should == 'Smith'
      new_user.email.should == 'user@facebook.com'
      new_user.should be_persisted
      new_user.authentications.size.should == 1
    end

    it "doesn't create a user if it is missing required fields" do
      @token.info.email = nil
      new_user = User.from_oauth(@token)
      new_user.first_name.should == 'John'
      new_user.last_name.should == 'Smith'
      new_user.email.should be_nil
      new_user.should_not be_persisted
    end

    it "retrieves existing user" do
      user.authentications.create!(
        :provider => @token.provider,
        :uid => @token.uid,
        :token => 'token789'
      )

      new_user = User.from_oauth(@token)
      new_user.id.should == user.id
    end

    it "stores authentication" do
      user.authentications.size.should == 0

      user.attributes = {
        :oauth_provider => 'facebook',
        :oauth_token => 'token456',
        :oauth_secret => 'secret456',
        :oauth_uid => '456'
      }

      #user.updated_at = Time.now

      user.save.should be_true
      user.reload

      user.authentications.size.should == 1
      auth = user.authentications.first
      auth.provider.should == 'facebook'
      auth.uid.should == '456'
    end
  end
end
require 'spec_helper'

describe User do
  let(:user){ create(:user) }

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

  context "Avatar" do
    it "sets and deletes the avatar" do
      user.delete_avatar = true
      mock_avatar = mock(:dirty? => false)
      mock_avatar.should_receive(:clear)
      user.stub(:avatar => mock_avatar)
      user.save.should be_true
    end
  end

  context "Preferences" do
    it "stores prefered city" do
      city = create(:city)
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

    it "retrieves linked account info" do
      user.facebook_authentication.should be_nil
      user.not_yet_authenticated_providers.should == [:facebook, :twitter]
      auth = user.authentications.create!(
        :provider => 'facebook',
        :uid => '123',
        :token => 'token789'
      )
      user.facebook_authentication.should == auth
      user.not_yet_authenticated_providers.should == [:twitter]
    end
  end

  context "auto_signup" do
    it "creates a new user account" do
      name = "Stewie Griffin"
      email = "ste@gmail.com"
      user = nil

      expect {
        user = User.auto_signup(name, email)
      }.to change(User, :count).by(1)

      user.should be_persisted # saved
      user.reset_password_token.should_not be_nil
      user.reset_password_sent_at.should_not be_nil
    end
  end
end
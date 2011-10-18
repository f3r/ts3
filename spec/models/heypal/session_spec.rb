require 'spec_helper'

describe Heypal::Session do

  context "User" do

    it "should be able to signin to the site" do

      @heypal_session = Heypal::Session.create({:email => 'test', :password => 'test'})

      @heypal_session.should be_valid

      @heypal_session.authentication_token.should be_present
    end

  end

end

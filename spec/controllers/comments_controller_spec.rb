require 'spec_helper'

describe CommentsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @agent = FactoryGirl.create(:user)
  end

  context "Guest" do
    before(:each) do
      login_as @user
    end

    it "posts a questions" do
      place = double(:id => '1234', :user => @agent)
      Heypal::Place.stub(:find).and_return(place)

      mailer = double('mailer', :deliver => true)
      UserMailer.should_receive(:new_question).and_return(mailer)
      Comment.any_instance.stub(:place).and_return(place)

      xhr :post, :create, :place_id => '1234', :comment => {
        :comment => 'Pets allowed?'
      }

      response.should be_success

      q = Comment.last
      q.place_id.should == 1234
    end
  end

  context "Agent" do
    before(:each) do
      place = double(:id => '1234', :user => @agent)
      Heypal::Place.stub(:find).and_return(place)
      login_as @agent
    end

    it "deletes a question" do
      q = Comment.create!(:user => @agent, :comment => 'Delete me', :place_id => '1234')
      lambda {
        xhr :delete, :destroy, :place_id => '123', :id => q.id
      }.should change(Comment, :count).by(-1)
    end

    it "responds a question" do
      q = Comment.create!(:user => @agent, :comment => '1 + 1?', :place_id => '1234')

      mailer = double('mailer', :deliver => true)
      UserMailer.should_receive(:new_question_reply).and_return(mailer)

      xhr :post, :reply_to_message, :place_id => '1234', :comment_id => q.id, :comment => {
        :comment => '2'
      }

      response.should be_success

      q2 = Comment.last
      q2.replying_to.should == q.id
    end
  end
end

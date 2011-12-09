class MessagesController < ApplicationController
  layout 'plain'
  before_filter :login_required, :only => [:new, :wizard, :create]

  # Retrieves all conversations
  def index
    @results = Heypal::Message.list({"access_token" => current_token})
  end

  # Retrieves all messages with a user
  def conversation
    @messages  = Heypal::Message.messages({"id" => params[:id],"access_token" => current_token})
    if !@messages.nil? && !@messages['messages'].blank?
      if @messages['messages'][0]['from']['id'] == current_user['id']
        @with_name = "#{@messages['messages'][0]['to']['first_name'][0]}. #{@messages['messages'][0]['to']['last_name']}"
        @with_id   = @messages['messages'][0]['to']['id']
      else
        @with_name = "#{@messages['messages'][0]['from']['first_name'][0]}. #{@messages['messages'][0]['from']['last_name']}"
        @with_id   = @messages['messages'][0]['from']['id']
      end
    end
  end

  # Posts a new message to a user
  def create
    message_params = {}
    message_params.merge!({:access_token => current_token, :id => params['id'], :message => params['message']['message']})
    @message = Heypal::Message.create(message_params)

    render :partial => '/comments/add_message'
  end
end

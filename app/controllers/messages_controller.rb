class MessagesController < ApplicationController
  layout 'plain'
  before_filter :login_required, :only => [:new, :create]
  respond_to :html, :json, :js

  # Retrieves all conversations
  def index
    @result = Heypal::Message.list({"access_token" => current_token})
    @conversations = @result['conversations']
  end

  # Retrieves all messages with a user
  def conversation
    #@with = Heypal::User.info("id" => params[:id])
    result  = Heypal::Message.messages({"id" => params[:id],"access_token" => current_token})
    @conversation = result['conversation']
    @messages = result['messages']
    @inquiry = @conversation['inquiry']
  end

  # Posts a new message to a user
  def create
    message_params = {
      :access_token => current_token, :id => params['id'], :message => params['message']['message']
    }
    @message = Heypal::Message.create(message_params)

    respond_with do |format|
      format.html {
        redirect_to conversation_path(params['id'])
      }
      # format.js {
      #   #must have show action for message to render single message
      #   render :partial => '/messages/add_message'
      # }
    end
  end

  def destroy
    @with = Heypal::User.info("id" => params[:id])
    @deleted, @result = Heypal::Message.delete('user_id' => params['id'], 'access_token' => current_token)

    flash[:notice] = "Conversation with #{@with['first_name'].chr}. #{@with['last_name']} deleted."
    redirect_to messages_path
  end

  #mark as read
  def mark_as_read
    @message = Heypal::Message.mark_as_read('user_id' => params[:id], 'access_token' => current_token)
    if @message['stat'] == "ok"
      flash[:notice] = t(:marked_as_read)
    else
      flash[:error] = t(:failed_read)
    end
    redirect_to messages_path
  end

  #mark as unread
  def mark_as_unread
    @message = Heypal::Message.mark_as_unread('user_id' => params[:id], 'access_token' => current_token)
    if @message['stat'] == "ok"
      flash[:notice] = t(:marked_as_unread)
    else
      flash[:error] = t(:failed_unread)
    end
    redirect_to messages_path
  end
end

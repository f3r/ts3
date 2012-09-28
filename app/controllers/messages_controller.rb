class MessagesController < PrivateController
  layout 'plain'
  respond_to :html #, :json, :js

  # Retrieves all conversations
  def index
    @conversations = Messenger.get_conversations(current_user)
  end

  # Add a reply to a conversation
  def update
    @message = Message.new(:body => params[:message][:body])
    if Messenger.add_reply(current_user, params[:id], @message)
      redirect_to message_path(params[:id])
    end
  end

  # Retrieves all the messages from a conversation
  def show
    @conversation, @messages = Messenger.get_conversation_messages(current_user, params[:id])
    Messenger.mark_as_read(current_user, @conversation.id) if @conversation
  end

  # Archive a conversation
  def destroy
    if Messenger.archive(current_user, params[:id])
     redirect_to messages_path
    end
  end

  #mark as read
  def mark_as_read
    if Messenger.mark_as_unread(current_user, params[:id])
      flash[:notice] = t("messages.marked_as_read")
    else
      flash[:error] = t("messages.failed_read")
    end
    redirect_to messages_path
  end

  #mark as unread
  def mark_as_unread
    if Messenger.mark_as_unread(current_user, params[:id])
      flash[:notice] = t("messages.marked_as_unread")
    else
      flash[:error] = t("messages.failed_unread")
    end
    redirect_to messages_path
  end
  
  # Retrieves all archived conversations
  def archived_messages
    @archived_conversations = Messenger.get_archived_conversations(current_user)
  end
  
  # Retrieves all the messages from an archived conversation
  def show_archived
    @conversation, @messages = Messenger.get_conversation_messages(current_user, params[:id])
  end
  
  # un-archive the message
  def un_archive
    if Messenger.un_archive(current_user, params[:id])
      flash[:notice] = t("archives.marked_as_un_archive")
    else
      flash[:error] = t("archives.failed_un_archive")
    end
    redirect_to archived_messages_url
  end
  
end

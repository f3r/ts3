class CommentsController < ApplicationController
  before_filter :login_required
  before_filter :find_place

  def create
    comment_params = params[:comment]
    comment_params[:access_token] = current_token
    comment_params[:place_id] = params[:place_id]

    comment = Heypal::Comment.new(comment_params)
    saved, @comment = comment.save

    if saved
      render :partial => '/comments/add_comment'
    else
      render :text => 'error'
    end
  end

  def reply_to_message
    comment_params = params[:comment]
    comment_params[:access_token] = current_token
    comment_params[:place_id] = params[:place_id]
    comment_params[:replying_to] = @replying_to = params[:comment_id]

    comment = Heypal::Comment.new(comment_params)
    saved, @comment = comment.save

    if saved
      respond_to do |format|
        format.js { render :layout => false }
      end
    else
      render :text => 'error'
    end
  end

  def destroy
    @comment_params = {'id' => params[:id], 'access_token' => current_token, 'place_id' => params[:place_id] }
    @comment = Heypal::Comment.delete(@comment_params)
    @type = params[:type]
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  private

  def find_place
    @place = Heypal::Place.find(params[:place_id], current_token)
    @owner = @place['user']
  end
end

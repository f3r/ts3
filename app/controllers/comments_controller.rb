class CommentsController < ApplicationController
  before_filter :login_required
  before_filter :find_place

  def create
    @comment = current_user.comments.new(params[:comment])
    @comment.place = @place

    if @comment.save
      UserMailer.new_question(@comment.place.user, @comment).deliver if @comment.place
      render '/comments/create', :layout => nil
    else
      render '/comments/validation_error', :layout => nil
    end
  end

  def reply_to_message
    comment_params = params[:comment]
    comment_params[:place_id] = params[:place_id]
    comment_params[:replying_to] = @replying_to = params[:comment_id]

    @comment = current_user.comments.new(comment_params)

    if @comment.save
      UserMailer.new_question_reply(@comment.user, @comment).deliver
      respond_to do |format|
        format.js { render :layout => false }
      end
    else
      render :text => 'error'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    @question_id = params[:qId] if params.key?(:qId)

    @type = params[:type]
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  private

  def find_place
    @place = Place.find(params[:place_id])
    @owner = @place.user
  end
end

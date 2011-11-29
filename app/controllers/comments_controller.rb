class CommentsController < ApplicationController
  before_filter :find_place

  def index
    
  end

  def show
    
  end

  def create
    comment_params = params[:comment]
    comment_params[:access_token] = current_token
    comment_params[:place_id] = params[:place_id]

    comment = Heypal::Comment.new(comment_params)
    saved, @comment = comment.save
    logger.info(@comment.inspect)

    if saved
      render :partial => '/comments/add_comment'
    else
      render :text => 'error'
    end
  end

  def reply_to_message
    
  end

  def delete
    
  end

  private

  def find_place
    @place = Heypal::Place.find(params[:place_id], current_token)
    @owner = @place['user']
  end
end

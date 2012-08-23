class FeedbacksController < ApplicationController
  def new
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def create
    SystemMailer.user_feedback(current_user, params[:type], params[:message]).deliver

    flash[:notice] = t("pages.suggest_thank_you_message", :city => params[:message])
    redirect_to root_path
  end
  
  def contact
    SystemMailer.user_contact(params[:contact]).deliver

    flash[:notice] = t("pages.contact_query_response_message")
    redirect_to root_path
  end
end

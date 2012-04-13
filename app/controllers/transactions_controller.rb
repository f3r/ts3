class TransactionsController < ApplicationController
  layout 'plain'
  before_filter :login_required
  respond_to :html, :js

  def request_rental
    @request_rental = Heypal::Place.request_rental(params[:id], current_token)
    if @confirm_rental['stat'] == "ok"
      @response = "success"
      @inquiry = @request_rental['inquiry']
    else
      @response = "error"
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
end

class TransactionsController < ApplicationController
  layout 'plain'
  before_filter :login_required
  respond_to :html, :js

  def update
    @result = Heypal::Transaction.update(current_token, params)
    if @result['stat'] == "ok"
      @inquiry = @result['inquiry']
      respond_to do |format|
        format.js { render :layout => false, :template => "transactions/change_state.js.erb" }
      end
    else
    end
  end

  # def request_rental
  #   @request_rental = Heypal::Place.request_rental(params[:id], current_token)
  #   if @request_rental['stat'] == "ok"
  #     @response = "success"
  #     @inquiry = @request_rental['inquiry']
  #   else
  #     @response = "error"
  #   end
  #   respond_to do |format|
  #     format.js { render :layout => false, :template => "transactions/change_state.js.erb" }
  #   end
  # end
  # 
  # def preapprove_rental
  #   @preapprove_rental = Heypal::Place.preapprove_rental( params[:id], current_token)
  # 
  #   if @preapprove_rental['stat'] == 'ok'
  #     @success = true
  #     @inquiry = @preapprove_rental['inquiry']
  #   end
  #   respond_to do |format|
  #     format.js { render :layout => false, :template => "transactions/change_state.js.erb" }
  #   end
  # end
end

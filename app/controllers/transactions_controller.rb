class TransactionsController < PrivateController
  respond_to :js

  def update
    @transaction = Transaction.find(params[:id])

    if @transaction.change_state!(params[:event])
      respond_to do |format|
        format.js { render :layout => false, :template => "transactions/change_state.js.erb" }
      end
    else
    end
  end
end

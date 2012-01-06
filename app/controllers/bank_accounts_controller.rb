class BankAccountsController < ApplicationController

  # def new
  #   @bank_account = Heypal::BankAccount.new
  # end

  def create
    @bank_account = Heypal::BankAccount.new(params[:user])
    if @bank_account.valid? && @bank_account.save
      redirect_to profile_path
    else
      render :action => :edit, :controller => :users
    end
  end

  def update
    user = Heypal::User.show('access_token' => current_token)
    @bank_account = Heypal::BankAccount.new(params_with_token(:bank_account))
    if @bank_account.valid? && @bank_account.save(current_token)
      flash[:notice] = 'You successfully updated your bank account'
      redirect_to profile_path
    else
      @user = Heypal::User.show('access_token' => current_token)
      @user_auth = Heypal::User.list('access_token' => current_token)
      render :template => "users/edit"
    end
  end
  
end

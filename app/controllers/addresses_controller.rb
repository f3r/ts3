class AddressesController < ApplicationController

  # def new
  #   @address = Heypal::Address.new
  # end

  def create
    @address = Heypal::Address.new(params[:user])

    if @address.valid? && @address.save
      redirect_to profile_path
    else
      render :action => :edit, :controller => :users
    end
  end

  def update
    user = Heypal::User.show('access_token' => current_token)
    @address = Heypal::Address.new(params_with_token(:address))

    if @address.valid? && @address.save(current_token)
      redirect_to profile_path
    else
      @user = Heypal::User.show('access_token' => current_token)
      @user_auth = Heypal::User.list('access_token' => current_token)
      render :template => "users/edit"
    end
  end
  
end

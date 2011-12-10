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
      if params[:address][:check_in] && params[:address][:check_out]
        redirect_to availability_place_path(:id => params[:address][:place_id],:check_in => params[:address][:check_in], :check_out => params[:address][:check_out])
      else
        redirect_to profile_path
      end
    else
      @user = Heypal::User.show('access_token' => current_token)
      @user_auth = Heypal::User.list('access_token' => current_token)
      render :template => "users/edit"
    end
  end
  
end

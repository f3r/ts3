class UsersController < ApplicationController

  def new
    @user = Heypal::User.new
  end

  def create
    @user = Heypal::User.new(params[:user])
    if @user.valid? && @user.save
      redirect_to '/dashboard'
    else
      render :action => :new
    end
  end

  def confirm
    if params['confirmation-token'].present?
      if Heypal::User.confirm(params[:confirmation_token])
        flash[:notice] = t(:user_confirmed) 
        redirect_to '/login'
      else
        flash[:notice] = t(:invalid_confirmation_code)
      end
    end
  end

end

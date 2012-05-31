class ProfilesController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.attributes = params[:user]

    if @user.save
      if @user.password_confirmation
        # Log in again after changing the password
        sign_in(@user, :bypass => true)
        flash[:notice] = 'You successfully changed your password.'
      else
        flash[:notice] = 'You successfully updated your profile.'
      end
      redirect_to profile_path
    else
      render :action => :edit
    end
  end
end

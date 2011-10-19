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

end

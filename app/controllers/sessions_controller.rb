class SessionsController < ApplicationController
  
  def create

    if params[:email].present? && params[:password].present?

      @heypal_session = Heypal::Session.create(params)

      if @heypal_session.valid?
        sign_in @heypal_session
        redirect_to '/dashboard'
      else
        flash[:error] = t(:invalid_login)
        redirect_to login_path
      end

    else
      flash[:error] = t(:invalid_login)
      redirect_to login_path
    end

  end

  def destroy
    sign_out
    redirect_to root_path
  end

end

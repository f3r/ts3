class SessionsController < ApplicationController
  
  def create

    if params[:email].present? && params[:password].present?

      @heypal_session = Heypal::Session.create(params)

      if @heypal_session.valid?
        sign_in @heypal_session

        if params[:oauth_token].present?
          connect
        end
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
  
  def auth
    unless logged_in?
      @heypal_session = Heypal::Session.signin_via_oauth(oauth_provider, {:oauth_token => oauth_token})

      if @heypal_session.valid?
        sign_in @heypal_session
        redirect_to '/dashboard'
      else
        flash[:notice] = t(:signup_needed_to_connect)
        render :template => 'users/connect'
      end

    else
      connect
      redirect_to '/dashboard'      
      return
    end
  end

  def connect
    Heypal::Session.create_oauth({:access_token => current_token, :oauth_token => oauth_token}) 
  end

  def fail
    flash[:error] = t(:authentication_fail)
    redirect_to login_path
  end

  def oauth_token
    omniauth = request.env['omniauth.auth']
    @oauth_token = omniauth['credentials']['token']
  end

  def oauth_provider
    @oauth_provider = request.env['omniauth.auth']['provider']
  end

  def destroy
    sign_out
    redirect_to root_path
  end




end

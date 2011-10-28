class SessionsController < ApplicationController
  
  def create

    if params[:email].present? && params[:password].present?

      @heypal_session = Heypal::Session.create(params)

      if @heypal_session.valid?

        sign_in @heypal_session


        # IF OAUTH session, create the oauth token as well.
        if params[:oauth_token].present?

          @create_response = Heypal::Session.create_oauth({
                                    :access_token => @heypal_session.authentication_token,
                                    :oauth_token => { 
                                        'provider' => params['oauth_provider'], 'uid' => params[:oauth_uid], 'credentials' => {'token' => params[:oauth_token], 'secret' => ''}}
                                    })

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
      
      # Attempt to sign in (check if there's an existing oauth record)
      @heypal_session = Heypal::Session.signin_via_oauth(oauth_provider, {:oauth_token => 
                                                         {'provider' => oauth_provider, 'uid' => oauth_uid,
                                                           'credentials' => {'token' => oauth_token}
                                                         }})

      # IF it's existing it should log in the user
      if @heypal_session.valid?
        sign_in @heypal_session
        redirect_to '/dashboard'
      else
        # Ask the user to connect the account
        flash[:notice] = t(:signup_needed_to_connect)
        render :template => 'users/connect'
      end

    else

      connect
      redirect_to '/dashboard'      
      return
    end
  end

  # Connect FB or TWitter to a logged in and existing Heypal account
  def connect

    @create_response = Heypal::Session.create_oauth({
                            :access_token => @heypal_session.authentication_token,
                            :oauth_token => { 
                                'provider' => oauth_provider, 
                                'uid' => oauth_uid,
                                'credentials' => {'token' => oauth_token}
                            }})
  end

  def fail
    flash[:error] = t(:authentication_fail)
    redirect_to login_path
  end

  def omniauth
    @omniauth = request.env['omniauth.auth']    
  end

  def oauth_token
    @oauth_token = omniauth['credentials']['token']
  end

  def oauth_provider
    @oauth_provider = omniauth['provider']
  end

  def oauth_uid
    @oauth_uid = omniauth['uid']
  end

  def destroy
    sign_out
    redirect_to root_path
  end




end

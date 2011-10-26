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
  
  def auth
    omniauth = request.env['omniauth.auth']
    
    if omniauth['provider'] == 'twitter'
 

      # CHECK if the oauth is valid     
      Heypal::Session.valid_oauth?({:oauth_token => omniauth['credentials']['token']})

      # CREATE the Record?
      Heypal::Session.create_oauth({:access_token => omniauth['credentials']['secret'], :oauth_token => omniauth['credentials']['token']})

      # 
      @heypal_session = Heypal::Session.signin_via_twitter({:access_token => omniauth['credentials']['secret'], :oauth_token => omniauth['credentials']['token']})
        

    elsif omniauth['provider'] == 'facebook'
      
      @heypal_session = Heypal::Session.create_oauth({:oauth_token => omniauth['credentials']['token']}) 
      @heypal_session = Heypal::Session.signin_via_facebook({:oauth_token => omniauth['credentials']['token']})

    end

    if @heypal_session.valid?
      redirect_to '/'
    else

    end

      #render :text => {:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'], :secret => omniauth['credentials']['secret']}      


  end

  def destroy
    sign_out
    redirect_to root_path
  end




end

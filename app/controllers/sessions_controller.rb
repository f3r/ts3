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
      if Heypal::Session.valid_oauth?({:oauth_token => omniauth['credentials']['token']})
  
        # Sign In 
        @heypal_session = Heypal::Session.signin_via_twitter({:access_token => omniauth['credentials']['secret'], :oauth_token => omniauth['credentials']['token']})
      
      else
        # Q 1: Do I sign up the user w/o the password OR shall I ask for the password
      end 

    elsif omniauth['provider'] == 'facebook'
      
      #@heypal_session = Heypal::Session.create_oauth({:oauth_token => omniauth['credentials']['token']}) 
      #@heypal_session = Heypal::Session.signin_via_facebook({:oauth_token => omniauth['credentials']['token']})

    end

    #if @heypal_session.valid?
      #redirect_to '/'
    #else

    #end

    render :text => {:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'], :secret => omniauth['credentials']['secret']}      

  end

  ##
  # Attach a facebook/email account to an existing account
  #
  def connect
    # Create the Record?
    # This should be sending the email as well OR Facebook/Twitter UID, specially for Facebook because it doesn't have access token
    Heypal::Session.create_oauth({:access_token => omniauth['credentials']['secret'], :oauth_token => omniauth['credentials']['token']})    

    redirect_to '/'
  end

  def destroy
    sign_out
    redirect_to root_path
  end




end

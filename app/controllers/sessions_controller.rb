class SessionsController < ApplicationController
  layout 'single'

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
          if (current_user.avatar.nil?)
            avatar_pic = params[:oauth_provider].eql?('facebook') ? "#{params[:avatar_url]}?type=large" : params[:avatar_url].gsub('normal', 'bigger')
            user_data = {'access_token' => current_token, 'avatar_url' => avatar_pic}
            # FIXME: 1966?
            # user_data = user_data.merge('birthdate' => '1966-01-01') if current_user.birthdate.nil?
            user_data = user_data.merge('birthdate' => oauth_birthday) if current_user.birthdate.nil? && params[:oauth_provider].eql?('facebook')
            user = Heypal::User.update(user_data)
          end
          session['current_user'] = Heypal::User.show('access_token' => current_token).merge('role' => @heypal_session['role'])
        else
          #save user data in session
          session['current_user'] = Heypal::User.show('access_token' => current_token).merge('role' => @heypal_session['role'])
        end
        redirect_to '/places'  
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
                                                           'credentials' => {'token' => oauth_token}, 'user_info' => {'name' => oauth_name,
                                                           'email' => oauth_email, 'first_name' => oauth_firstname, 'last_name' => oauth_lastname,
                                                           'image' => oauth_image}
                                                         }})
      # IF it's existing it should log in the user
      if @heypal_session.valid?
        sign_in @heypal_session
        #save user data in session
        if (current_user.avatar.nil?)
          avatar_url = oauth_provider.eql?('facebook') ? oauth_image.gsub('square', 'large') : oauth_image.gsub('normal', 'bigger')
          user_data = {
            'access_token' => current_token, 'avatar_url' => avatar_url
          }
          user = Heypal::User.update(user_data)
        end
        session['current_user'] = Heypal::User.show('access_token' => current_token).merge('role' => @heypal_session['role'])
        redirect_to '/profile'
      else
        # Ask the user to connect the account
        flash[:notice] = t(:signup_needed_to_connect)
        render :template => 'users/connect'
      end
    else
      connect
      flash[:notice] = "#{oauth_provider.capitalize} is connected in your account."
      redirect_to '/profile'
      return
    end
  end

  # Connect FB or TWitter to a logged in and existing Heypal account
  def connect
    @create_response = Heypal::Session.create_oauth({
                            :access_token => current_token,
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

  def omniauth_userinfo
    @omniauth_userinfo = omniauth['user_info']
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

  def oauth_name
    @oauth_name = omniauth_userinfo['name']
  end

  def oauth_firstname
    @oauth_firstname = omniauth_userinfo['first_name']
  end

  def oauth_lastname
    @oauth_lastname = omniauth_userinfo['last_name']
  end

  def oauth_email
    @oauth_email = omniauth_userinfo['email']
  end

  def oauth_birthday
    @oauth_birthday = omniauth['extra']['user_hash']['birthday']
  end

  def oauth_image
    @oauth_image = omniauth_userinfo['image']
  end

  def destroy
    sign_out
    session[:current_user] = nil
    redirect_to root_path
  end
end

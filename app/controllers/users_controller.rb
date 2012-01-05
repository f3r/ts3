class UsersController < ApplicationController
  def new
    @user = Heypal::User.new
    render :layout => 'single'
  end

  def create
    @user = Heypal::User.new(params[:user])

    @user.oauth_token = {'provider' => params['oauth_provider'],
      'uid' => params[:oauth_uid],
      'credentials' => {
        'token' => params[:oauth_token],
        'secret' => ''
      }
    }

    if @user.valid? && @user.save
      redirect_to signup_complete_path
    else
      render :action => :new, :layout => 'single'
    end
  end

  def confirm
     if params['confirmation_token']
      result = Heypal::User.confirm({'confirmation_token' => params['confirmation_token']})
      if params['confirmation_token'].present? && result['stat'].eql?('ok')
        if result['email_change'] == true
          flash[:notice] = t(:email_confirmed)
        else
          flash[:notice] = t(:user_confirmed)
        end
        sign_in result
        #if sign up using fb/twitter
        auth = Heypal::User.list('access_token' => current_token)
        unless auth['authentications'].blank?
          user_auth = auth['authentications'][0]
          if current_user.avatar.nil?
            avatar_pic = user_auth['provider'].eql?('facebook') ? "https://graph.facebook.com/#{user_auth['uid']}/picture?type=large" : "http://api.twitter.com/1/users/profile_image/#{user_auth['uid']}.jpg?size=bigger"
            user_data = {'access_token' => current_token, 'avatar_url' => avatar_pic}
            user_data = user_data.merge('birthdate' => '1966-01-01') if current_user.birthdate.nil?
            user = Heypal::User.update(user_data)
          end
        end
        redirect_to '/places'
      else
        flash[:error] = t(:invalid_confirmation_code)
        render :layout => 'single'
      end

    elsif params['email']

      if params['email'].present? &&  Heypal::User.resend_confirmation({:email => params['email']})
        flash[:notice] = t(:confirmation_email_sent)
        redirect_to login_path, :layout => 'single'
      else
        flash[:error] = t(:invalid_email)
        render :layout => 'single'
      end

    end

  end

  def reset_password
    if request.post?
      if params['email']
        if params['email'].present? && Heypal::User.reset_password({:email => params[:email]})
          flash[:notice] = t(:password_reset_instruction_sent)
          redirect_to login_path
        else
          flash[:error] = t(:password_reset_failed)
        end
      else
        flash[:error] = t(:password_reset_failed)
      end
    end

    render :layout => 'single'
  end

  def items
  end

  def received
  end

  def connect
  end

  def confirm_reset_password
    if request.post?
      if params['reset_password_token'].present? && Heypal::User.confirm_reset_password(params)
        flash[:notice] = t(:password_reset_success)
        redirect_to login_path
      else
        flash[:error] = t(:password_reset_failed)
      end
    end

    render :layout => 'single'
  end

  def signup_complete

  end

  def show
    if logged_in? && params['id'].blank?
      @user = Heypal::User.show('access_token' => current_token)
      @user_auth = Heypal::User.list('access_token' => current_token)
    else
      @user = Heypal::User.info('id' => params[:id])
      @places = Heypal::User.places('id' => params[:id])
      render :layout => 'plain'
    end
  end

  def edit
    @user = Heypal::User.show('access_token' => current_token)
    @address = Heypal::Address.show('access_token' => current_token)
    @user_auth = Heypal::User.list('access_token' => current_token)
  end

  def update
    birthdate = "#{params[:birthdate][:year]}/#{params[:birthdate][:month]}/#{params[:birthdate][:day]}".to_date rescue nil
    params[:user][:birthdate] = birthdate if birthdate
    @user = Heypal::User.new(params_with_token(:user))
    @address = Heypal::Address.show('access_token' => current_token)

    if @user.valid? && @user.save
      user = Heypal::User.show('access_token' => current_token)
      session['current_user'] = user
      if !user['unconfirmed_email'].blank?
        flash[:notice] = 'You successfully updated your profile! However, you need to confirm your email. Please check your email and click the link to verify it.'
      else
        flash[:notice] = 'You successfully updated your profile.'
      end
      redirect_to profile_path
    else
      @user_auth = Heypal::User.list('access_token' => current_token)
      render :action => :edit
    end
  end

  def change_password
    @user = Heypal::User.new(params_with_token(:new_password))
    @address = Heypal::Address.show('access_token' => current_token)

    if @user.valid? && @user.save
      flash[:notice] = 'You successfully updated your password.'
      redirect_to profile_path
    else
      @user_auth = Heypal::User.list('access_token' => current_token)
      render :action => :edit
    end
  end

  def change_preference
    preference = if params.key?("pref_language")
      :pref_language
    elsif params.key?("pref_currency")
      :pref_currency
    elsif params.key?("pref_size_unit")
      :pref_size_unit
    end

    params['access_token'] = current_token

    # Set to cookies
    cookies[preference] = params[preference]

    if logged_in?
      if Heypal::User.update(params)
        current_user[preference.to_s] = params[preference]
        #render :json => {:stat => true}
        session['current_user'] = Heypal::User.show('access_token' => current_token)
        render :js => %w(window.location.reload();)
      else
        render :json => {:stat => false}
      end
    else
      render :js => %w($('#popup-registration').modal({show: true, backdrop: 'static', keyboard: true}); return false;)
    end
  end
  
  def cancel_email_change
    if Heypal::User.cancel_email_change('access_token' => current_token)
      session['current_user'] = Heypal::User.show('access_token' => current_token)
      render :js => %w(window.location.reload();)
    else
      render :json => {:stat => false}
    end
  end
  
end

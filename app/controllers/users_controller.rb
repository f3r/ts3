class UsersController < ApplicationController
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
    if @user['role'] == "agent"
      @bank_account = Heypal::BankAccount.show('access_token' => current_token)
    end
    @user_auth = Heypal::User.list('access_token' => current_token)
  end

  def update
    birthdate = "#{params[:birthdate][:year]}/#{params[:birthdate][:month]}/#{params[:birthdate][:day]}".to_date rescue nil
    params[:user][:birthdate] = birthdate if birthdate
    @user = Heypal::User.new(params_with_token(:user))
    @address = Heypal::Address.show('access_token' => current_token)
    # @bank_account = Heypal::BankAccount.show('access_token' => current_token)

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
      unless request.referer.include?('signup')
        render :js => %w($('#popup-registration').modal(); return false;)
      else
        render :js => %w(window.location.reload();)
      end
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

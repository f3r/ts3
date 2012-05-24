class UsersController < ApplicationController
  def show
<<<<<<< HEAD
    @user = Heypal::User.info('id' => params[:id])
    @places = Heypal::User.places('id' => params[:id])
    render :layout => 'plain'
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
        #session['current_user'] = Heypal::User.show('access_token' => current_token)
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
    @user = User.agent.find(params[:id])
    @places = @user.places
  end
end

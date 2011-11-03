class UsersController < ApplicationController

  def new
    @user = Heypal::User.new
  end

  def create

    post_params = params[:user]

    # IF OAUTH session, create the oauth token as well.
    if params[:oauth_token].present?
      post_params = post_params.merge({ 
                                      'oauth_token' => { 
                                      'provider' => params['oauth_provider'], 
                                      'uid' => params[:oauth_uid], 
                                      'credentials' => { 'token' => 
                                          params[:oauth_token], 
                                            'secret' => ''}
                                    }})
    end

    @user = Heypal::User.new(post_params)

    if @user.valid? && @user.save

      redirect_to signup_complete_path
    else
      render :action => :new
    end
  end

  def confirm
    if params['confirmation_token']

      if params['confirmation_token'].present? && Heypal::User.confirm({'confirmation_token' => params['confirmation_token']})
        flash[:notice] = t(:user_confirmed) 
        redirect_to login_path
      else
        flash[:error] = t(:invalid_confirmation_code)
      end

    elsif params['email']

      if params['email'].present? &&  Heypal::User.resend_confirmation({:email => params['email']})
        flash[:notice] = t(:confirmation_email_sent)
        redirect_to login_path
      else
        flash[:error] = t(:invalid_email)
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

  end

  def items
  end

  def received
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

  end

  def signup_complete

  end

  def show
    @user = Heypal::User.show('access_token' => params[:id])
    logger.info(@user)
    @user_auth = Heypal::User.list('access_token' => current_token)
    logger.info(@authentications)
  end

  def edit
    @user = Heypal::User.show('access_token' => current_token)
    logger.info(@user)
    logger.info(@user.class)
    @user_auth = Heypal::User.list('access_token' => current_token)
    logger.info(@user_auth)
  end

  def update
    @user = Heypal::User.update(params[:user])
    logger.info(@user)
    if @user['stat'].eql?('ok')
      redirect_to user_path(:access_token => params[:access_token])
    else
      redirect_to edit_user_path(current_token)
    end
  end
end

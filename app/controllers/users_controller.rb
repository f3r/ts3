class UsersController < ApplicationController

  def new
    @user = Heypal::User.new
  end

  def create
    @user = Heypal::User.new(params[:user])

    #if params[:user][:oauth_token].present?
      @user.oauth_token = {'provider' => params['oauth_provider'],
        'uid' => params[:oauth_uid],
        'credentials' => {
          'token' => params[:oauth_token],
          'secret' => ''
        }
      }
    #end

    #Rails.logger.info "POST PARAMS: #{@user.inspect}"
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
    @user = Heypal::User.show('access_token' => current_token)

    @user_auth = Heypal::User.list('access_token' => current_token)
  end

  def edit
    @user = Heypal::User.show('access_token' => current_token)
    @user_auth = Heypal::User.list('access_token' => current_token)
  end

  def update
    @user = Heypal::User.new(params_with_token(:user)) 

    if @user.valid? && @user.save
      redirect_to profile_path
    else
      @user_auth = Heypal::User.list('access_token' => current_token)
      render :action => :edit
    end
  end
end

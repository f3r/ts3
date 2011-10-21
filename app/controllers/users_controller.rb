class UsersController < ApplicationController

  def new
    @user = Heypal::User.new
  end

  def create
    @user = Heypal::User.new(params[:user])
    if @user.valid? && @user.save
      redirect_to '/dashboard'
    else
      render :action => :new
    end
  end

  def confirm
    if params['confirmation-token']

      if params['confirmation-token'].present? && Heypal::User.confirm({'confirmation_token' => params['confirmation-token']})
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

end

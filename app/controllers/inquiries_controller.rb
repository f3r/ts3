class InquiriesController < ApplicationController
  respond_to :js

  def create
    # :name             => params[:name],
    # :email            => params[:email],
    # :date_start       => params[:date_start],
    # :length_stay      => params[:length_stay],
    # :length_stay_type => params[:length_stay_type],
    # :message          => params[:questions]

    # @resource = Place.with_permissions_to(:read).find(params[:place_id])
    @resource = resource_class.published.find(params[:id])
    @user = current_user

    unless @user
      @user = User.auto_signup(params[:name], params[:email])
      if @user.persisted?
        sign_in @user
      end
      @just_created = true
    end

    if @user.persisted?
      @inquiry = Inquiry.create_and_notify(@resource, @user, params[:inquiry])
    end

    respond_to do |format|
      format.js { render :layout => false, :template => "inquiries/create" }
    end
  end

protected

  def resource_class
    SiteConfig.product_class
  end
end

# def confirm_inquiry
#   if logged_in? || verify_recaptcha()
# =>else
#     @recaptcha_error = true
#   end
# end
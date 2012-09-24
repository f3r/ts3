class InquiriesController < ApplicationController
  respond_to :js, :html

  def create
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
      @inquiry = Inquiry.where(:user_id => @user.id, :product_id => @resource.product.id).first
      
      unless @inquiry
        @inquiry = Inquiry.create_and_notify(@resource, @user, params[:inquiry])
      end
    end

    # Quick hack to get status from mobile version
    # TODO: Fix with MIME types
    if params[:mobile].present?
      redirect_to mobile_inquire_path
    else
      respond_to do |format|
        format.js { render :layout => false, :template => "inquiries/create" }
      end
    end
  end
end
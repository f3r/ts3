class ContactController < ApplicationController
  respond_to :js, :html
   
  def create
    user = current_user
    
    if user.present?
      params[:contact_request][:name] = user.full_name
      params[:contact_request][:email] = user.email
    end
    
    @contact = ContactRequest.create_contact(params[:contact_request])
    
    SystemMailer.user_contact(params[:contact_request]).deliver if @contact.persisted?
    
    respond_to do |format|
      format.js { render :layout => false, :template => "contact/create" }
    end
  end
end
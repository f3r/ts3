class HomeController < ApplicationController
  def suggest
    Heypal::User.feedback(
      :access_token => current_token,
      :type => :city_suggestion,
      :message => {
        :city => params[:city],
        :email => params[:email]
      }
    )

    flash[:notice] = "Thank you for your message. SquareStays is expanding and we will let you know when #{params['city']} is available!"
    redirect_to root_path
  end

  def robot
    robots = File.read(Rails.root + "config/robots.#{Rails.env}.txt")
    render :text => robots, :layout => false, :content_type => "text/plain"
  end

  def set_ref
    respond_to do |format|
      session[:user_return_to] = params[:ref] if params[:ref] && !params[:ref].blank?
      format.json { render :inline => "ok" }
    end 
  end
  
  def staticpage
    #get the content from back-end
    @staticpages = Cmspage.getPageContent(params[:pages])
  end

end